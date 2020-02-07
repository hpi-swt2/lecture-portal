class IcalController < ActionController::Base
  before_action :get_user

  def show
    @calendar = generate_calendar
    render plain: @calendar.to_ical
  end

  private
    def get_user
      @user = User.find_by(hash_id: params[:hash_id])
    end

    def generate_calendar
      calendar = Icalendar::Calendar.new
      @user.participating_courses.each do |course|
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
      calendar
    end
end
