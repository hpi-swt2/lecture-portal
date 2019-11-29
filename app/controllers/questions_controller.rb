class QuestionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # GET /questions
  def index
  end

  # GET api/questions
  def apiIndex
    questions = Question.order(created_at: :desc)
    render json: questions
  end

  # POST /api/questions
  def apiCreate
    # TODO: save current_user to question 
    question = Question.new(question_params)
    if question.save
      serialized_question = ActiveModelSerializers::Adapter::Json.new(
          QuestionSerializer.new(question)
      ).serializable_hash
      ActionCable.server.broadcast('questions', serialized_question)
      head :ok
    end
  end

  private
    def question_params
      params.require(:question).permit(:author, :content)
    end
end
