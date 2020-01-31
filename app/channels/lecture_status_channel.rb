class LectureStatusChannel < ApplicationCable::Channel
    def subscribed
      stream_from "lecture_status_channel"
    end
  
    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end
  