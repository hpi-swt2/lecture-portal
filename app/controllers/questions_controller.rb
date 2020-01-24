class QuestionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :get_course
  before_action :get_lecture
  before_action :validate_joined_user_or_owner
  before_action :validate_lecture_running_or_active, except: [:index]
  before_action :get_question, only: [:upvote, :resolve]
  before_action :validate_question_unresolved, only: [:upvote, :resolve]

  # POST /questions
  def create
    # only allow students to write questions
    if current_user.is_student
      # create new question based on stripped received question content and current user
      question = Question.new(content: params[:content].strip, author: current_user, lecture: @lecture)
      if question.save
        # serialize question and broadcast it via ActionCable to subscribers
        serialized_question = ActiveModelSerializers::Adapter::Json.new(
          QuestionSerializer.new(question)
        ).serializable_hash
        QuestionsChannel.broadcast_to(@lecture, serialized_question)
        head :ok
      end
    else
      head :forbidden
    end
  end

  # POST /questions/:id/upvote
  def upvote
    if @question && current_user.is_student && @question.author != current_user && !@question.upvoters.include?(current_user) && @question.lecture == @lecture
      @question.upvoters << current_user
      if @question.save
        # broadcast upvote via ActionCable
        QuestionUpvotingChannel.broadcast_to(@lecture, {
            question_id: @question.id,
            upvoter_id: current_user.id
        })
        head :ok
      end
    else
      head :forbidden
    end
  end

  # POST /questions/:id/resolve
  def resolve
    # only allow author or lecturer to resolve the question
    if @question && (!current_user.is_student || @question.author == current_user) && @question.lecture == @lecture
      @question.resolved = true
      if @question.save
        # broadcast resolving via ActionCable
        QuestionResolvingChannel.broadcast_to(@lecture, @question.id)
        head :ok
      end
    else
      head :forbidden
    end
  end

  private
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

    def validate_joined_user_or_owner
      isStudent = current_user.is_student
      isJoinedStudent = isStudent && @lecture.participating_students.include?(current_user)
      isLectureOwner = !isStudent && @lecture.lecturer == current_user
      return head :forbidden unless isJoinedStudent || isLectureOwner
    end

    def validate_lecture_running_or_active
      head :forbidden unless @lecture.allow_interactions?
    end

    def get_question
      @question = Question.find(params[:id])
    end

    def validate_question_unresolved
      head :forbidden if @question.resolved
    end
end
