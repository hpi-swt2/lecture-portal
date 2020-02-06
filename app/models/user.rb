class User < ApplicationRecord
  has_one :feedback, dependent: :destroy
  has_many :uploaded_files, foreign_key: "author_id"
  has_many :lectures, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :questions
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
  # DRY
  def self.secret_key_default
    "IAmALecturer"
  end
  # secret_key is used like any other property by devise. The getter initializes the secret key entry in the registrations form.
  def secret_key
    ""
  end

  # the setter gets the value the user has entered into the secret_key field
  def secret_key=(secret_key)
    actual_key = ENV.fetch("SECRET_KEY", User.secret_key_default)
    self.is_student = !(secret_key == actual_key)
  end

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
