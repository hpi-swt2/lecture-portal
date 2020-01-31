class User < ApplicationRecord
  has_one :feedback, dependent: :destroy
  has_many :uploaded_files, foreign_key: "author_id"
  has_many :lectures, dependent: :destroy, foreign_key: "lecturer_id"
  has_many :courses, dependent: :destroy, foreign_key: "creator_id"
  has_many :questions, foreign_key: "author_id"
  has_and_belongs_to_many :participating_lectures, class_name: :Lecture
  has_and_belongs_to_many :participating_courses, class_name: :Course
  has_and_belongs_to_many :upvoted_questions, class_name: :Question

  before_validation :assign_hash_id

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :is_student, inclusion: { in: [ true, false ] }
  validates :hash_id, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private
    def assign_hash_id
      if self.hash_id === nil || self.hash_id === ""
        begin
          self.hash_id = SecureRandom.urlsafe_base64(20)
        end until unique_hash_id?
      end
    end

    def unique_hash_id?
      !self.class.exists?(hash_id: self.hash_id)
    end
end
