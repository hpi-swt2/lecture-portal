class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy, :stop, :save_answers, :stop_start]
  before_action :get_lecture
  before_action :authenticate_user!
  before_action :set_is_student

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
      redirect_to lecture_polls_path(@lecture), notice: "You are a student. You can not create polls."
    else
      @poll = @lecture.polls.build
    end
  end

  # GET /polls/1/edit
  def edit
    if @is_student
      if !@poll.is_active
        redirect_to lecture_polls_path(@lecture), notice: "This poll is closed."
      else
        get_users_answers
        render :answer
      end
    end
  end

  # GET /polls/1/stop
  def stop_start
    if @poll.is_active
      if @poll.update(is_active: false)
        redirect_to lecture_poll_path(@lecture, @poll), notice: "You stopped the poll!"
      else
        redirect_to lecture_poll_path(@lecture, @poll), notice: "This did not work :("
      end
    else
      if @poll.update(is_active: true)
        redirect_to lecture_poll_path(@lecture, @poll), notice: "You started the poll!"
      else
        redirect_to lecture_poll_path(@lecture, @poll), notice: "This did not work :("
      end
    end
  end

  # POST /polls/id/save_answers
  def save_answers
    answer_params
    current_poll_answers = params[:answers]
    poll = Poll.find(params[:id])
    if !poll.is_active
        redirect_to lecture_polls_path(@lecture), notice: "This poll is closed."
    else
      # delete answers from student to poll
      Answer.where(poll_id: poll.id, student_id: current_user.id).destroy_all
      # save new answers
      current_poll_answers.each { |answer|
        puts(answer[:value])
        puts(!!answer[:value]==true)
        if answer[:value] == true
          current_answer = Answer.new(poll: poll, student_id: current_user.id, option_id: answer[:id])
          current_answer.save
        end
      }

      # gather votes for poll
      @poll.gather_vote_results
      redirect_to lecture_poll_path(@lecture, params[:id]), notice: "You answered successfully ;-)"
    end
  end

  # POST /polls
  def create
    current_poll_params = poll_params
    @poll = @lecture.polls.build(title: current_poll_params[:title], is_multiselect: current_poll_params[:is_multiselect], is_active: current_poll_params[:is_active])
    poll_options = current_poll_params[:poll_options]
    for poll_option in poll_options do
      poll_option_description = poll_option.values_at(1)
      @poll.poll_options.build(description: poll_option_description.to_param)
    end
    if @poll.save
      redirect_to lecture_polls_path(@lecture), notice: "Poll was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /polls/1
  def update
    current_poll_params = poll_params
    if @poll.update(title: current_poll_params[:title], is_multiselect: current_poll_params[:is_multiselect], is_active: current_poll_params[:is_active])
      # Remove all previously existing options so there are no conflicts with the new/updated ones.
      existingOptions = PollOption.where(poll_id: @poll.id)
      poll_options = current_poll_params[:poll_options]
      for poll_option in poll_options do
        poll_option_description = poll_option.values_at(1)
        @poll.poll_options.build(description: poll_option_description.to_param)
      end
      if @poll.save
        redirect_to lecture_polls_path(@lecture), notice: "Poll was successfully updated."
      else
        render :edit
      end
    else
      render :edit
    end
  end

  # DELETE /polls/1
  def destroy
    @poll.destroy
    redirect_to lecture_polls_path(@lecture), notice: "Poll was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def poll_params
      params.require(:poll).permit(:title, :is_multiselect, :lecture_id, :is_active, :number_of_options, poll_options: params[:poll][:poll_options].keys)
    end

    def get_lecture
      @lecture = Lecture.find(params[:lecture_id])
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
end
