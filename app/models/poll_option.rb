class PollOption < ApplicationRecord
  belongs_to :poll
  validates :description, presence: true, allow_blank: true
  validates :votes, numericality: { only_integer: true }
end
