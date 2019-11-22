class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'questions'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    question = Question.find(data["id"])
    question.update!(content: data["content"])
    ActionCable.server.broadcast('questions', data)
  end
end
