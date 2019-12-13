class Course < ApplicationRecord
  validates :name, presence: true, length: { in: 2..40 }
  enum status: { open: "open", closed: "closed" }
end
