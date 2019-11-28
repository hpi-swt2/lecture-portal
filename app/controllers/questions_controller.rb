class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /questions
  def index
  end

  # GET api/questions
  def apiIndex
    questions = Question.all
    render json: questions
  end

  # POST /api/questions
  def apiCreate
    question = Question.new(question_params)
    if question.save
      serialized_question = ActiveModelSerializers::Adapter::Json.new(
          QuestionSerializer.new(question)
      ).serializable_hash
      ActionCable.server.broadcast('questions', serialized_question)
      head :ok
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:author, :content)
    end
end
