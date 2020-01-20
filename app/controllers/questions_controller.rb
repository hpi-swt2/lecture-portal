class QuestionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :get_lecture
  before_action :validate_joined_user_or_owner

  # GET /questions
  def index
    if current_user.is_student
      questions = Question.where(lecture: @lecture).order(created_at: :DESC)
    else
      questions = Question.where(lecture: @lecture)
        .left_joins(:upvoters)
        .group(:id)
        .order(Arel.sql("COUNT(users.id) DESC"), created_at: :DESC)
    end
    render json: questions
  end

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
    question = Question.find(params[:id])
    if question && current_user.is_student && question.author != current_user && !question.upvoters.include?(current_user) && question.lecture == @lecture

      question.upvoters << current_user
      if question.save
        # broadcast upvote via ActionCable
        QuestionUpvotingChannel.broadcast_to(@lecture, {
            question_id: question.id,
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
    question = Question.find(params[:id])
    # only allow author or lecturer to resolve the question
    if question && (!current_user.is_student || question.author == current_user) && question.lecture == @lecture
      question.resolved = true
      if question.save
        # broadcast resolving via ActionCable
        QuestionResolvingChannel.broadcast_to(@lecture, question.id)
        head :ok
      end
    else
      head :forbidden
    end
  end

  private
    def get_lecture
      @lecture = Lecture.find(params[:lecture_id])
    end

    def validate_joined_user_or_owner
      isStudent = current_user.is_student
      isJoinedStudent = isStudent && @lecture.participating_students.include?(current_user)
      isLectureOwner = !isStudent && @lecture.lecturer == current_user
      unless isJoinedStudent || isLectureOwner
        redirect_to course_lectures_path(@lecture.course)
      end    end
end
