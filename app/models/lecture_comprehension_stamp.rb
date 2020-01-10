class LectureComprehensionStamp < ApplicationRecord
  @@number_of_states = 3

  belongs_to :user
  belongs_to :lecture
  validates :status, presence: true, inclusion: { in: [0, 1, 2] }

  def eliminate
    ComprehensionStampChannel.broadcast_to(@lecture, "expired") # TODO only send to corresponding user
  end

  def timestamp
    return self.updated_at
  end

  def LectureComprehensionStamp.number_of_states
    return @@number_of_states
  end
end
