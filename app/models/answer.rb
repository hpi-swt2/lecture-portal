class Answer < ApplicationRecord
  belongs_to :poll
  validates :student_id, presence: true
  validates :option_id, presence: true
end
