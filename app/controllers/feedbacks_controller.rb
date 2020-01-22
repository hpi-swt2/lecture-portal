class FeedbacksController < ApplicationController

  def create
    @lecture = Lecture.find(params[:lecture_id])
    if params[:commit] == "CREATE"
      @feedback = @lecture.feedbacks.create(content: comment_params[:content], user: current_user)
    elsif params[:commit] == "UPDATE"
      @feedback = @lecture.feedbacks.where(user_id: current_user.id)
      @feedback.update(comment_params)
    #redirect_to course_lecture_path(@lecture.course, @lecture)
    end
    head :no_content
  end

  def update
    @lecture = Lecture.find(params[:lecture_id])
    @feedback.update(comment_params)
  end

  private
    def comment_params
      params.require(:feedback).permit(:content, :user)
    end
end
