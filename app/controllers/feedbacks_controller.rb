class FeedbacksController < ApplicationController
  before_action :validate_joined_user_or_owner
  before_action :set_lecture

  def create
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
      # return head :forbidden unless isJoinedStudent || isLectureOwner
      unless isJoinedStudent || isLectureOwner
        redirect_to course_lectures_path(@lecture.course)
      end
    end

    def set_lecture
      @lecture = Lecture.find(params[:lecture_id])
    end
end
