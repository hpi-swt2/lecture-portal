class FeedbacksController < ApplicationController
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @feedback = @lecture.feedbacks.create(comment_params)
    redirect_to lecture_path(@lecture)
  end

  private
    def comment_params
      params.require(:feedback).permit(:content)
    end
end
