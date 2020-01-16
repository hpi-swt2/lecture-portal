class LectureComprehensionStamp < ApplicationRecord
  @@number_of_states = 3
  @@seconds_till_comprehension_timeout = 60*10 # 10min

  belongs_to :user
  belongs_to :lecture
  validates :status, presence: true, inclusion: { in: [0, 1, 2] }

  def broadcastUpdate
    ComprehensionStampChannel.broadcast_to(@lecture, "updated") # TODO only send to Lecturer
  end

  def broadcastElimination
    ComprehensionStampChannel.broadcast_to(@lecture, "expired") # TODO only send to corresponding user
  end

  def timestamp
    return self.updated_at
  end

  def LectureComprehensionStamp.number_of_states
    return @@number_of_states
  end

  def LectureComprehensionStamp.seconds_till_comprehension_timeout
    return @@seconds_till_comprehension_timeout
  end
end
