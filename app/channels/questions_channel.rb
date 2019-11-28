class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'questions'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # question = Question.find(data["id"])
    # question.update!(content: data["content"])
    # question = Question.new(:content => data["content"], :author => 'Testi')
    # if question.save
    #   serialized_question = ActiveModelSerializers::Adapter::Json.new(
    #       QuestionSerializer.new(question)
    #   ).serializable_hash
    #   ActionCable.server.broadcast 'questions', serialized_question
    #   head :ok
    # end
  end
end
