class Lecture < ApplicationRecord
  validates :name, presence: true, length: { in: 2..40 }
  validates :enrollment_key, presence: true, length: { in: 3..20 }
  validates :is_running, inclusion: { in: [ true, false ] }
end
