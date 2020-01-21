class FeedbacksController < ApplicationController

  def create
    @lecture = Lecture.find(params[:lecture_id])
    @feedback = @lecture.feedbacks.create(content: comment_params[:content], user: current_user)
    #redirect_to course_lecture_path(@lecture.course, @lecture)
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
