class Lecture < ApplicationRecord
  belongs_to :lecturer, class_name: :User
  has_and_belongs_to_many :participating_students, class_name: :User
  has_many :polls, dependent: :destroy
  has_many :feedbacks
  has_many :lecture_comprehension_stamps, class_name: :LectureComprehensionStamp
  belongs_to :course
  has_many :uploaded_files, as: :allowsUpload
  enum status: { created: "created", running: "running", ended: "ended" }
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validates :name, presence: true, length: { in: 2..40 }
  validates :enrollment_key, length: { in: 3..20, if: :enrollment_key_present? }
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

  def readonly?
    if self.id
      db_lecture = Lecture.find(self.id)
      return db_lecture.status == "ended"
    end
    false
  end

  def enrollment_key_present?
    enrollment_key.present?
  end

  def Lecture.eliminate_comprehension_stamps
    Lecture.where(status: "running").each { |lecture|
      lecture.eliminate_own_comp_stamps
    }
  end

  def eliminate_own_comp_stamps
    cur_time = Time.now
    changed = false
    self.lecture_comprehension_stamps.each { |stamp|
      if (cur_time - stamp.timestamp) >= LectureComprehensionStamp.seconds_till_comp_timeout
        stamp.broadcast_elimination
        changed = true
      end
    }
    if changed
      broadcast_comprehension_status
    end
  end

  def broadcast_comprehension_status
    ActionCable.server.broadcast "lecture_comprehension_stamp:#{self.id}", comprehension_state_lecture
  end

  def comprehension_state(current_user)
    if current_user.is_student
      comprehension_state_student(current_user)
    else
      comprehension_state_lecture
    end
  end

  private
    def comprehension_state_student(current_user)
      stamp = self.lecture_comprehension_stamps.where(user: current_user).max { |a, b| a.timestamp <=> b.timestamp }
      if stamp
        if stamp.timestamp <= Time.now - LectureComprehensionStamp.seconds_till_comp_timeout
          { status: -1, last_update: stamp.timestamp }
        else
          { status: stamp.status, last_update: stamp.timestamp }
        end
      else
        { status: -1, last_update: nil }
      end
    end
    def comprehension_state_lecture
      status = Array.new(LectureComprehensionStamp.number_of_states, 0)
      status.size.times do |i|
        status[i] = self.lecture_comprehension_stamps.where("status = ? and updated_at > ?", i, Time.now - LectureComprehensionStamp.seconds_till_comp_timeout).count
      end
      last_update = self.lecture_comprehension_stamps.max { |a, b| a.timestamp <=> b.timestamp }
      if !last_update
        { status: status, last_update: nil }
      else
        { status: status, last_update: last_update.timestamp }
      end
    end
end
