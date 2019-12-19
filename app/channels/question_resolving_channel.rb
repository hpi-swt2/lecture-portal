class QuestionResolvingChannel < ApplicationCable::Channel
  def subscribed
    lecture = Lecture.find(params[:lecture])
    stream_for lecture
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
