class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :content, :author
end