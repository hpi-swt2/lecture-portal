class Api::QuestionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # GET /api/questions
  def index
    questions = Question.where(resolved: false).order(created_at: :desc)
    render json: questions
  end

  # POST /api/questions
  def create
    # only allow students to write questions
    if current_user.is_student
      # create new question based on stripped received question content and current user
      question = Question.new(content: params[:content].strip, author: current_user)
      if question.save
        # serialize question and broadcast it via ActionCable to subscribers
        serialized_question = ActiveModelSerializers::Adapter::Json.new(
          QuestionSerializer.new(question)
        ).serializable_hash
        ActionCable.server.broadcast("questions_channel", serialized_question)
        head :ok
      end
    end
  end

  # POST /api/question/:id/upvote
  def upvote
    question = Question.find(params[:id])
    if question && current_user.is_student && question.author != current_user && !question.upvoters.include?(current_user)

      question.upvoters << current_user
      if question.save
        # broadcast upvote via ActionCable
        ActionCable.server.broadcast(
          "question_upvoting_channel",
          {
            question: question.id,
            upvoter: current_user.id
          }
        )
      end
    end
  end
  # POST /api/question/:id/resolve
  def resolve
    question = Question.find(params[:id])
    # only allow author or lecturer to resolve the question
    if question && (!current_user.is_student || question.author == current_user)
      question.resolved = true
      if question.save
        # broadcast resolving via ActionCable
        ActionCable.server.broadcast("question_resolving_channel", question.id)
        head :ok
      end
    end
  end
end
