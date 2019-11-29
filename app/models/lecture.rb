class Lecture < ApplicationRecord
  validates :name, presence: true, length: { in: 2..40 }
  validates :enrollment_key, presence: true, length: { in: 3..20 }
  validates :is_running, inclusion: { in: [ true, false ] }

  scope :active, -> { where is_running: true }

  def set_active
    self.is_running=true
  end

  def set_inactive
    self.is_running=false
  end
end
