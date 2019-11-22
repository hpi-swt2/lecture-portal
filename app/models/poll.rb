class Poll < ApplicationRecord
  belongs_to :lecture
  has_many :poll_options

  validates :title, presence: true
  validates :is_multiselect, inclusion: { in: [true, false] }
end
