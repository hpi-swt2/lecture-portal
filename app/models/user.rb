class User < ApplicationRecord
  has_many :lectures, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_and_belongs_to_many :participating_lectures, class_name: :Lecture
  has_and_belongs_to_many :participating_courses, class_name: :Course


  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :is_student, inclusion: { in: [ true, false ] }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :questions
end
