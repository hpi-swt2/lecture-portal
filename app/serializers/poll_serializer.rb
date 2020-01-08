class PollSerializer < ActiveModel::Serializer
  attributes :id, :poll_options, :title, :created_at, :is_active, :lecture_id
end

