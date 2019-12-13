class Lecture < ApplicationRecord
  belongs_to :lecturer, class_name: :User
  has_and_belongs_to_many :participating_students, class_name: :User
  has_many :polls, dependent: :destroy
  has_many :feedbacks
  enum status: { created: "created", running: "running", ended: "ended" }

  validates :name, presence: true, length: { in: 2..40 }
  validates :enrollment_key, presence: true, length: { in: 3..20 }
  scope :active, -> { where status: "running" }
  validates_with LectureValidator


  def set_active
    self.status = :running
  end

  def set_inactive
    self.status = :ended
  end

  def join_lecture(student)
    if !self.participating_students.include?(student)
      self.participating_students << student
    end
  end

  def leave_lecture(student)
    if self.participating_students.include?(student)
      self.participating_students.delete(student)
    end
  end

  def ==(other_lecture)
    return status == other_lecture.status && polls_enabled == other_lecture.polls_enabled && questions_enabled == other_lecture.questions_enabled \
    && description == other_lecture.description && enrollment_key == other_lecture.enrollment_key && id == other_lecture.id
  end

  def !=(other_lecture)
    return !(self == other_lecture)
  end
end

class LectureValidator < ActiveModel::Validator
  def validate(lecture)
    if lecture.ended?
      db_lecture = Lecture.find_by_lecturer_id(lecture.id)
      attributes_changed = lecture != db_lecture
      if attributes_changed
        lecture.errors[:base] << "You cannot edit a lecture when is has been archived."
      end
    end
  end
end

