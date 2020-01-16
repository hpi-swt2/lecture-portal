class Lecture < ApplicationRecord
  belongs_to :lecturer, class_name: :User
  has_and_belongs_to_many :participating_students, class_name: :User
  has_many :polls, dependent: :destroy
  has_many :feedbacks
  has_many :lecture_comprehension_stamps, class_name: :LectureComprehensionStamp
  # do the same thing with course later
  has_many :uploaded_files, as: :allowsUpload
  enum status: { created: "created", running: "running", ended: "ended" }

  validates :name, presence: true, length: { in: 2..40 }
  validates :enrollment_key, presence: true, length: { in: 3..20 }
  scope :active, -> { where status: "running" }

  @@seconds_till_comprehension_timeout = 60*10 # 10min
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

  def Lecture.eliminateComprehensionStamps
    puts "Do elimination checks!"
    Lecture.where(status: "running").each { |lecture|
      lecture.eliminateOwnComprehensionStamps
    }
  end

  def eliminateOwnComprehensionStamps
    puts "check!"
    cur_time = Time.now
    changed = false
    self.lecture_comprehension_stamps.each { |stamp|
      if (cur_time - stamp.timestamp) >= @@seconds_till_comprehension_timeout
        stamp.eliminate
        changed = true
      end
    }
    if changed
      ComprehensionStampChannel.broadcast_to(self, getComprehensionStatus) # TODO only send to lecturer
    end
  end

  def getComprehensionStatus
    status = Array.new(LectureComprehensionStamp.number_of_states, 0)
    status.size.times do |i|
      status[i] = self.lecture_comprehension_stamps.where("status = ? and updated_at > ?", i, Time.now - @@seconds_till_comprehension_timeout).count
    end
    last_update = self.lecture_comprehension_stamps.max { |a, b| a.timestamp <=> b.timestamp }  # TODO handle no stamps
    return { status: status, last_update: last_update.timestamp }
  end
end
