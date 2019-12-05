class PollOption < ApplicationRecord
  belongs_to :poll
  validates :description, presence: true, allow_blank: true
end
