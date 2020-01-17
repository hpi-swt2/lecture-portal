class FeedbacksController < ApplicationController
  before_action :validate_joined_user_or_owner
  def create
    @lecture = Lecture.find(params[:lecture_id])
    @feedback = @lecture.feedbacks.create(comment_params)
  end

  private
    def comment_params
      params.require(:feedback).permit(:content)
    end

    def validate_joined_user_or_owner
      isStudent = current_user.is_student
      isJoinedStudent = isStudent && @lecture.participating_students.include?(current_user)
      isLectureOwner = !isStudent && @lecture.lecturer == current_user
      return head :forbidden unless isJoinedStudent || isLectureOwner
    end
end
