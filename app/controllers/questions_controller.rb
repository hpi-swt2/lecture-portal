class QuestionsController < ApplicationController
  before_action :authenticate_user!

  # GET /questions
  def index
  end
  
end
