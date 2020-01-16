class ComprehensionStampChannel < ApplicationCable::Channel
  def subscribed
    lecture = Lecture.find(params[:lecture_id])
    if current_connection_user.is_student
      stream_from "lecture_comprehension_stamp:#{lecture.id}:#{current_connection_user.id}"
    else
      stream_from "lecture_comprehension_stamp:#{lecture.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
