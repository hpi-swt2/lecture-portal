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

  def Lecture.eliminate_comprehension_stamps
    puts "Do elimination checks!"
    Lecture.where(status: "running").each { |lecture|
      lecture.eliminate_own_comp_stamps
    }
  end

  def eliminate_own_comp_stamps
    puts "check!"
    cur_time = Time.now
    changed = false
    self.lecture_comprehension_stamps.each { |stamp|
      if (cur_time - stamp.timestamp) >= LectureComprehensionStamp.seconds_till_comp_timeout
          stamp.broadcast_elimination
          changed = true
      end
    }
    if changed
      ActionCable.server.broadcast "lecture_comprehension_stamp:#{self.id}", get_comprehension_status
      #ComprehensionStampChannel.broadcast_to(self.lecturer, getComprehensionStatus) # TODO only send to lecturer
    end
  end

  def get_comprehension_status
    status = Array.new(LectureComprehensionStamp.number_of_states, 0)
    status.size.times do |i|
      status[i] = self.lecture_comprehension_stamps.where("status = ? and updated_at > ?", i, Time.now - LectureComprehensionStamp.seconds_till_comprehension_timeout).count
    end
    last_update = self.lecture_comprehension_stamps.max { |a, b| a.timestamp <=> b.timestamp }
    if !last_update
      return { status: status, last_update: -1 }
    else
      return { status: status, last_update: last_update.timestamp }
    end
  end
end
