class Course < ApplicationRecord
  belongs_to :creator, class_name: :User
  has_and_belongs_to_many :participating_students, class_name: :User
  # this uses delete to remove related lectures, which in turn destroys them even if they are read only
  has_many :lectures, dependent: :delete_all
  validates :name, presence: true, length: { in: 2..40 }
  enum status: { open: "open", closed: "closed" }
  has_many :uploaded_files, as: :allowsUpload

  def join_course(student)
    unless self.participating_students.include?(student)
      self.participating_students << student
    end
  end

  def leave_course(student)
    if self.participating_students.include?(student)
      self.participating_students.delete(User.find(student.id))
    end
  end
end
