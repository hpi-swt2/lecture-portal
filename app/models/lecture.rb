class Lecture < ApplicationRecord
  belongs_to :lecturer, class_name: :User
  has_many :polls, dependent: :destroy
  enum status: { created: "created", running: "running", ended: "ended" }

  validates :name, presence: true, length: { in: 2..40 }
  validates :enrollment_key, presence: true, length: { in: 3..20 }
end
