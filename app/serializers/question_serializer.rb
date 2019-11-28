class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at
end