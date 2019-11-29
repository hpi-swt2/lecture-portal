class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :content, :author_id, :created_at
end