class LectureComprehensionStamp < ApplicationRecord
  @@number_of_states = 3

  belongs_to :user
  belongs_to :lecture
  validates :status, presence: true, inclusion: { in: [1, 2, 3] }

  def eliminate
    ComprehensionStampChannel.broadcast_to(@lecture, {stamp_id: self.id, status: "expired"}) # TODO only send to corresponding user
  end
end
