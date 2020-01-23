class PollOptionsChannel < ApplicationCable::Channel
  def subscribed
    poll = Poll.find(params[:poll_id])
    stream_for poll
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
