class Question < ApplicationRecord
  belongs_to :author, class_name: :User
  has_and_belongs_to_many :upvoters, class_name: :User

  validates :content, presence: true
  validates :author, presence: true

  def upvotes
    upvoters.count
  end
end
