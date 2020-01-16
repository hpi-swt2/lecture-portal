class LectureComprehensionStamp < ApplicationRecord
  @@number_of_states = 3
  @@seconds_till_comp_timeout = 60*10 # 10min

  belongs_to :user
  belongs_to :lecture
  validates :status, presence: true, inclusion: { in: (0..(@@number_of_states-1)) }


  def broadcast_update
    ActionCable.server.broadcast "lecture_comprehension_stamp:#{self.lecture_id}:#{self.user_id}",
                                 { :status => self.status, :last_update => self.timestamp }
  end

  def broadcast_elimination
    ComprehensionStampChannel.broadcast_to(@lecture, "expired") # TODO only send to corresponding user
  end

  def timestamp
    self.updated_at
  end

  def LectureComprehensionStamp.number_of_states
    return @@number_of_states
  end

  def LectureComprehensionStamp.seconds_till_comp_timeout
    return @@seconds_till_comp_timeout
  end
end
