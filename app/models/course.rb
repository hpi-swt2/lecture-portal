class Course < ApplicationRecord
  enum status: { open: "open", closed: "closed" }
end
