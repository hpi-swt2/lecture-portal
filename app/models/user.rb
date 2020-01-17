class User < ApplicationRecord
  has_many :uploaded_files, foreign_key: "author_id"
  has_many :lectures, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_one :calendar, dependent: :destroy
  has_and_belongs_to_many :participating_lectures, class_name: :Lecture
  has_and_belongs_to_many :participating_courses, class_name: :Course


  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :is_student, inclusion: { in: [ true, false ] }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :questions
  has_and_belongs_to_many :upvoted_questions, class_name: :Question

  def update_calendar
    calendar = Icalendar::Calendar.new
    self.participating_courses.each do |course|
      course.lectures.each do |lecture|
        event = Icalendar::Event.new
        event.summary = course.name + " - " + lecture.name
        event.dtstart = DateTime.new(
            lecture.date.year,
            lecture.date.month,
            lecture.date.day,
            lecture.start_time.hour,
            lecture.start_time.min,
            lecture.start_time.sec
        )
        event.dtend = DateTime.new(
            lecture.date.year,
            lecture.date.month,
            lecture.date.day,
            lecture.end_time.hour,
            lecture.end_time.min,
            lecture.end_time.sec
        )
        calendar.add_event(event)
      end
    end
    calendar.publish
    self.calendar.ical = calendar.to_ical
    self.calendar.save
  end

end
