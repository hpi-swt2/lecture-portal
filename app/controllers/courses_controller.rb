class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :validate_owner, only: [:edit, :update, :destroy]
  before_action :require_lecturer, only: [:edit, :update, :destroy]

  # GET /courses
  def index
    @courses = Course.all
  end

  # GET /courses/1
  def show
    @current_user = current_user
    @student_files = @course.uploaded_files.student_files
    @lecturer_files = @course.uploaded_files.lecturer_files
  end

  # GET /courses/new
  def new
    @course = Course.new
    @course.creator = current_user
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  def create
    @course = Course.new(course_params)
    @course.creator = current_user
    if @course.save
      redirect_to @course, notice: "Course was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /courses/1
  def update
    if @course.update(course_params)
      redirect_to @course, notice: "Course was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
    redirect_to courses_url, notice: "Course was successfully destroyed."
  end


  def join_course
    @course = Course.find(params[:id])
    @course.join_course(current_user)
    @course.save
    current_user.save
    update_calendar
    current_user.save
    redirect_to @course, notice: "You successfully joined the course."
  end

  def leave_course
    @course = Course.find(params[:id])
    @course.leave_course(current_user)
    @course.save
    current_user.save
    update_calendar
    current_user.save
    redirect_to root_path, notice: "You successfully left the course."
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(:name, :description, :status)
    end

    def validate_owner
      if @course.creator != current_user
        redirect_to @course, notice: "You can only access your own courses."
      end
    end

    def require_lecturer
      if current_user.is_student?
        redirect_to @course, notice: "You can't access this site as a student."
      end
    end

    def update_calendar
      calendar = Icalendar::Calendar.new
      current_user.participating_courses.each do |course|
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
      current_user.calendar.ical = calendar.to_ical
      current_user.calendar.save
    end
end
