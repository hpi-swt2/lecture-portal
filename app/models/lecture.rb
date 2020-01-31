class Lecture < ApplicationRecord
  before_save :update_lecture_status, if: lambda { |l| l.date_changed? || l.start_time_changed? || end_time_changed? }
  before_save :lecture_status_changed, if: lambda { |l| l.status_changed? }

  belongs_to :lecturer, class_name: :User
  has_and_belongs_to_many :participating_students, class_name: :User
  has_many :polls, dependent: :destroy
  has_many :feedbacks
  has_many :lecture_comprehension_stamps, class_name: :LectureComprehensionStamp
  belongs_to :course
  has_many :uploaded_files, as: :allowsUpload
  enum status: { created: "created", running: "running", active: "active", archived: "archived" }
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validates :name, presence: true, length: { in: 2..142 }
  validates :enrollment_key, length: { in: 3..20, if: :enrollment_key_present? }
  scope :running, -> { where status: "running" }
  scope :active, -> { running.or(where status: "active") }

  def join_lecture(student)
    unless self.participating_students.include?(student)
      self.participating_students << student
    end
  end

  def leave_lecture(student)
    if self.participating_students.include?(student)
      self.participating_students.delete(student)
    end
  end

  def readonly?
    if self.id
      db_lecture = Lecture.find(self.id)
      return db_lecture.status == "archived"
    end
    false
  end

  def allow_interactions?
    self.status.in?(["running", "active"])
  end

  def enrollment_key_present?
    enrollment_key.present?
  end

  def Lecture.handle_activations
    Lecture.where(status: [:created, :active, :running]).each { |lecture|
      if lecture.update_lecture_status
        lecture.save
      end
    }
  end

  def update_lecture_status
    old_status = self.status
    if self.date < Date.today
      set_archived
    elsif self.date > Date.today
      set_created
    elsif self.start_time.utc.seconds_since_midnight - 300 < Time.current.utc.seconds_since_midnight && self.end_time.utc.seconds_since_midnight + 300 > Time.current.utc.seconds_since_midnight
      set_running
    else
      set_active
    end
    old_status != self.status
  end

  def lecture_status_changed
    ActionCable.server.broadcast "lecture_status_channel", { lecture_id: self.id, course_id: self.course.id }
  end

  def allow_comprehension?
    self.status == "running"
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

  def close_all_polls
    self.polls.where(is_active: true).each { |poll|
      poll.close
    }
  end

  private
    def set_created
      self.status = :created
    end

    def set_active
      self.status = :active
    end

    def set_running
      self.status = :running
    end

    def set_archived
      self.status = :archived
      self.close_all_polls
    end

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
