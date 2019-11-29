class QuestionsApiController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # GET /api/questions
  def index
    questions = Question.order(created_at: :desc)
    render json: questions
  end

  # POST /api/questions
  def create
    puts params
    # create new question based on stripped received question content and current user
    question = Question.new(:content => params[:content].strip, :author => current_user)
    if question.save
      # serialize question and broadcast it via ActionCable to subscribers
      serialized_question = ActiveModelSerializers::Adapter::Json.new(
          QuestionSerializer.new(question)
      ).serializable_hash
      ActionCable.server.broadcast('questions_channel', serialized_question)
      head :ok
    end
  end
  
end
