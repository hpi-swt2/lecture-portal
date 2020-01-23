class FeedbacksController < ApplicationController
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @feedback = @lecture.feedbacks.create(comment_params)

    respond_to do |format|
      if @feedback.save
        # format.html {redirect_to @feedback, notice: 'User was successfully created.'}
        format.js
        # format.json {render json: @feedback, status: :created, location: @feedback }
      else
        format.html { render action: "new", notice: "Error" }
      end
    end
  end

  private
    def comment_params
      params.require(:feedback).permit(:content)
    end
end
