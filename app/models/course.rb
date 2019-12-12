class Course < ApplicationRecord
  #belongs_to :creator, class_name: :User
  has_many :lectures, dependent: :destroy

  enum status: { open: "open", closed: "closed" }
  validates :name, presence: true, length: { in: 2..40 }
end
