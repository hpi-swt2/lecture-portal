# needs to be at the top of the file
class LectureValidator < ActiveModel::Validator
  # changing attributes from a lecture is prohibited if the lecture ended
  def validate(lecture)
    if lecture.ended?
      db_lecture = Lecture.find_by_lecturer_id(lecture.id)
      attributes_changed = lecture != db_lecture
      if attributes_changed && lecture.id == db_lecture.id
        (lecture_set_from_running_to_ended = lecture.ended?) && db_lecture.running?
        other_attributes_than_status_changed = !lecture.compareIgnoreStatus(db_lecture)
        # allow changing the lecture from running to ended
        if !lecture_set_from_running_to_ended || other_attributes_than_status_changed
          lecture.errors[:base] << "You cannot edit a lecture when is has been archived."
        end
      end
    end
  end
end

class Lecture < ApplicationRecord
  belongs_to :lecturer, class_name: :User
  has_and_belongs_to_many :participating_students, class_name: :User
  has_many :polls, dependent: :destroy
  has_many :feedbacks
  # do the same thing with course later
  has_many :uploaded_files, as: :allowsUpload
  enum status: { created: "created", running: "running", ended: "ended" }

  validates :name, presence: true, length: { in: 2..40 }
  validates :enrollment_key, presence: true, length: { in: 3..20 }
  validates_with LectureValidator
  scope :active, -> { where status: "running" }


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

  def compareIgnoreStatus(other_lecture)
    name == other_lecture.name && polls_enabled == other_lecture.polls_enabled && questions_enabled == other_lecture.questions_enabled \
    && description == other_lecture.description && enrollment_key == other_lecture.enrollment_key && id == other_lecture.id
  end

  def ==(other_lecture)
    status == other_lecture.status && compareIgnoreStatus(other_lecture)
  end

  def !=(other_lecture)
    !(self == other_lecture)
  end

  def to_s
    "{ id:" + id.to_s + " status: " + status.to_s + " name: " + name + " description: " + description +
        " enrollment_key : " + enrollment_key + " polls_enabled " + polls_enabled.to_s + " questions_enabled " + questions_enabled.to_s + "}"
  end
end
