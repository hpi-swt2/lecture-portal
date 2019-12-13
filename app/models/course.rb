class Course < ApplicationRecord
  belongs_to :creator, class_name: :User
  validates :name, presence: true, length: { in: 2..40 }
  enum status: { open: "open", closed: "closed" }
end
