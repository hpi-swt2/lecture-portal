class PollOptionSerializer < ActiveModel::Serializer
  attributes :id, :description, :votes
end
