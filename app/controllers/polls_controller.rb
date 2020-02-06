class PollsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_course
  before_action :get_lecture
  before_action :set_poll, only: [:show, :edit, :update, :destroy, :stop, :save_answers, :stop_start, :answer]
  before_action :set_is_student
  before_action :validate_lecture_not_archived, except: [:index, :show, :serialized_options, :serialized_participants_count]
  before_action :validate_lecture_running_or_active, except: [:index, :create, :new, :edit, :update, :destroy, :show, :serialized_options, :serialized_participants_count]
  before_action do |controller|
    @hide_navbar = true
  end

  # GET /polls
  def index
    @polls = @lecture.polls
    if @is_student
      render :index_students
    end
  end

  # GET /polls/1
  def show
    get_users_answers
  end

  # GET /polls/new
  def new
    if @is_student
      redirect_to course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id), notice: "You are a student. You can not create polls."
    else
      @poll = @lecture.polls.build
    end
  end

  # GET /polls/1/edit
  def edit
    if @is_student
      redirect_to course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id), notice: "Only lecturers can edit polls. :("
    end
  end

  # GET /polls/1/answer
  def answer
    if @is_student
      if !@poll.is_active
        redirect_to course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id), notice: "This poll is closed."
      else
        get_users_answers
        render :answer
      end
    else
      redirect_to course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id), notice: "Only students can vote."
    end
  end

  # GET /polls/1/stop_start
  def stop_start
    if @poll.is_active
      start
    else
      stop
    end
  end

  # POST /polls/id/save_answers
  def save_answers
    answer_params
    current_poll_answers = params[:answers]
    poll = Poll.find(params[:id])
    if !poll.is_active
      redirect_to course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id), notice: "This poll is closed, you cannot answer it."
    else
      Answer.where(poll_id: poll.id, student_id: current_user.id).destroy_all
      save_given_answers(current_poll_answers, poll)
      @poll.gather_vote_results
      broadcast_state
      redirect_to course_lecture_poll_path(course_id: @lecture.course.id, lecture_id: @lecture.id, poll: @poll), notice: "You answered successfully ;-)"
    end
  end

  # POST /polls
  def create
    current_poll_params = poll_params
    @poll = @lecture.polls.build(title: current_poll_params[:title], is_multiselect: current_poll_params[:is_multiselect], status: "created")
    poll_option_params = current_poll_params[:poll_options]
    create_and_save_poll_options_from_params(poll_option_params)
    if @poll.save
      redirect_to course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id), notice: "Poll was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /polls/1
  def update
    current_poll_params = poll_params
    if @poll.update(title: current_poll_params[:title], is_multiselect: current_poll_params[:is_multiselect])
      poll_option_params = current_poll_params[:poll_options]
      # Remove all previously existing options so there are no conflicts with the new/updated ones.
      # Also delete answers to prevent foreign key constraint violations
      Answer.where(poll_id: @poll.id).destroy_all
      PollOption.where(poll_id: @poll.id).destroy_all
      create_and_save_poll_options_from_params(poll_option_params)
      if @poll.save
        broadcast_state
        redirect_to course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id), notice: "Poll was successfully updated."
      else
        render :edit
      end
    else
      render :edit
    end
  end

  # DELETE /polls/1
  def destroy
    # Also delete answers and options to prevent foreign key constraint violations
    Answer.where(poll_id: @poll.id).destroy_all
    PollOption.where(poll_id: @poll.id).destroy_all
    @poll.destroy
    redirect_to course_lecture_polls_path(course_id: @lecture.course.id, lecture_id: @lecture.id), notice: "Poll was successfully destroyed."
  end

  # GET /polls/:id/serializedOptions
  def serialized_options
    render json: get_serialized_options
  end

  # GET /polls/:id/serialize_participants_count
  def serialized_participants_count
    render json: get_serialized_participants_count
  end

  private
    def start
      if @poll.update(status: get_toggled_status)
        redirect_to course_lecture_poll_path(course_id: @lecture.course.id, lecture_id: @lecture.id, id: @poll.id), notice: "You started the poll!"
      else
        redirect_to course_lecture_poll_path(course_id: @lecture.course.id, lecture_id: @lecture.id, id: @poll.id), notice: "Starting the poll did not work :("
      end
    end

    def stop
      if @poll.update(status: get_toggled_status)
        redirect_to course_lecture_poll_path(course_id: @lecture.course.id, lecture_id: @lecture.id, id: @poll.id), notice: "You stopped the poll!"
      else
        redirect_to course_lecture_poll_path(course_id: @lecture.course.id, lecture_id: @lecture.id, id: @poll.id), notice: "Stopping the poll did not work :("
      end
    end

    # Send belonging poll_options to subscribers so they can update their data
    def broadcast_options
      poll = Poll.find(params[:id])
      if @poll.lecture == @lecture
        # broadcast update via ActionCable
        PollOptionsChannel.broadcast_to(poll, get_serialized_options)
      end
    end

    def get_serialized_options
      poll = Poll.find(params[:id])
      poll_options = poll.sorted_options
      poll_options.map { |option| ActiveModelSerializers::Adapter::Json.new(
        PollOptionSerializer.new(option)
      ).serializable_hash}
    end

    # Send belonging participants count of a poll to subscribers so they can update their data
    def broadcast_participants_count
      poll = Poll.find(params[:id])
      if @poll.lecture == @lecture
        # broadcast update via ActionCable
        PollParticipantsCountChannel.broadcast_to(poll, get_serialized_participants_count)
      end
    end

    def get_serialized_participants_count
      poll = Poll.find(params[:id])
      lecture = Lecture.find(params[:lecture_id])
      { "numberOfParticipants" => Answer.where(poll_id: poll.id).distinct.count(:student_id),
              "numberOfLectureUsers" => lecture.participating_students.length() }
    end

    def broadcast_state
      broadcast_options
      broadcast_participants_count
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def poll_params
      params.require(:poll).permit(:title, :is_multiselect, :lecture_id, :status, :number_of_options, poll_options: params[:poll][:poll_options].keys)
    end

    # This method looks for the course in the database and redirects with a failure if the course does not exist.
    def get_course
      @course = Course.find_by(id: params[:course_id])
      if @course.nil?
        redirect_to root_path, alert: "The course you requested does not exist."
      end
    end

    # This method looks for the lecture in the database and redirects with a failure if the lecture does not exist.
    def get_lecture
      @lecture = Lecture.find_by(id: params[:lecture_id])
      if @lecture.nil?
        redirect_to course_path(id: @course.id), alert: "The lecture you requested does not exist."
      end
    end

    def answer_params
      params.require(:poll).permit(:answers)
    end

    def get_users_answers
      @answers = Answer.where(poll_id: @poll.id, student_id: current_user.id)
    end

    def set_is_student
      @is_student = current_user.is_student
    end

    def save_given_answers(current_poll_answers, poll)
      current_poll_answers.each { |answer|
        if answer[:value] == true
          current_answer = Answer.new(poll: poll, student_id: current_user.id, option_id: answer[:id])
          current_answer.save
        end
      }
    end

    def validate_lecture_running_or_active
      head :forbidden unless @lecture.allow_interactions?
    end

    def validate_lecture_not_archived
      head :forbidden if @lecture.archived?
    end

    def create_and_save_poll_options_from_params(poll_option_params)
      i = 0
      for poll_option_param in poll_option_params do
        poll_option_description = poll_option_param.values_at(1)
        @poll.poll_options.build(description: poll_option_description.to_param, index: i)
        i = i + 1
      end
    end

    def get_toggled_status
      @poll.is_active ? "stopped" : "running"
    end
end
