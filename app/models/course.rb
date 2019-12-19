class Course < ApplicationRecord
  belongs_to :creator, class_name: :User
  has_and_belongs_to_many :participating_students, class_name: :User
  validates :name, presence: true, length: { in: 2..40 }
  enum status: { open: "open", closed: "closed" }

  def join_course(student)
    if !self.participating_students.include?(student)
      self.participating_students << student
    end
  end

end
