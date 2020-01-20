class User < ApplicationRecord
  has_many :uploaded_files, foreign_key: "author_id"
  has_many :lectures, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_and_belongs_to_many :participating_lectures, class_name: :Lecture
  has_and_belongs_to_many :participating_courses, class_name: :Course
  before_create :assign_hash_id


  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :is_student, inclusion: { in: [ true, false ] }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :questions
  has_and_belongs_to_many :upvoted_questions, class_name: :Question

  private

  def assign_hash_id
    self.hash_id = SecureRandom.urlsafe_base64(20) until unique_hash_id?
  end

  def unique_hash_id?
    !self.class.exists?(hash_id: self.hash_id)
  end
end
