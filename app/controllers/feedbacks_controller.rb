class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :get_course
  before_action :get_lecture
  #before_action :validate_joined_user_or_owner

  def create
    @lecture = Lecture.find(params[:lecture_id])
    if params[:commit] == "Submit"
      @feedback = @lecture.feedbacks.create(content: comment_params[:content], user: current_user)
    elsif params[:commit] == "Update"
      @feedback = @lecture.feedbacks.where(user_id: current_user.id)
      @feedback.update(comment_params)
    end
    head :no_content
  end

  private
    def comment_params
      params.require(:feedback).permit(:content, :user)
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
end
