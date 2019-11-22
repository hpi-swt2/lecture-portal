class Poll < ApplicationRecord
  has_many :poll_options, dependent: :destroy
  validates :title, presence: true
  validates :is_multiselect, inclusion: { in: [true, false] }

end
