class Lecture < ApplicationRecord
  belongs_to :lecturer, class_name: :User
  has_and_belongs_to_many :participating_students, class_name: :User
  has_many :polls, dependent: :destroy
  has_many :feedbacks
  enum status: { created: "created", running: "running", ended: "ended" }

  validates :name, presence: true, length: { in: 2..40 }
  validates :enrollment_key, presence: true, length: { in: 3..20 }
  scope :active, -> { where status: "running" }


  def set_active
    self.status = :running
  end

  def set_inactive
    self.status = :ended
  end

  def join_lecture(student)
    self.participating_students << student
  end
end
