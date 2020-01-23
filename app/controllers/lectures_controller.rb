class LecturesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_course
  before_action :set_lecture, only: [:show, :edit, :update, :destroy, :start_lecture, :end_lecture, :join_lecture, :leave_lecture, :update_comprehension_stamp, :get_comprehension]
  before_action :validate_lecture_owner, only: [:edit, :update, :destroy, :start_lecture, :end_lecture]
  before_action :validate_joined_user_or_owner, only: [:show, :update_comprehension_stamp, :get_comprehension]
  before_action :require_lecturer, except: [:current, :join_lecture, :leave_lecture, :show, :update_comprehension_stamp, :get_comprehension]
  before_action :require_student, only: [:join_lecture, :leave_lecture, :update_comprehension_stamp]
  before_action :validate_course_creator, only: [:create, :new]

  # GET /lectures
  def index
    @is_student = current_user.is_student
    @lectures = Lecture.where(lecturer: current_user)

    @running_lectures = @lectures.where(status: "running")
    @created_lectures = @lectures.where(status: "created")
    @ended_lectures = @lectures.where(status: "ended")
  end

  # GET courses/:course_id/lectures/1
  def show
    @current_user = current_user
    @uploaded_files = @lecture.uploaded_files
  end

  # GET courses/:course_id/lectures/new
  def new
    @lecture = @course.lectures.build
    @lecture.lecturer = current_user
  end

  # GET courses/:course_id/lectures/1/edit
  def edit
    if @lecture.status != "created"
      redirect_to course_lecture_path(@course, @lecture), alert: "This page is only available before a lecture was started. Use the settings tab instead."
    end
  end

  # POST courses/:course_id/lectures
  def create
    @lecture = @course.lectures.build(lecture_params)
    @lecture.lecturer = current_user
    if @lecture.save
      redirect_to course_lecture_path(@course, @lecture), notice: "Lecture was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT courses/:course_id/lectures/1
  def update
    if !@lecture.enrollment_key_present? && lecture_params[:enrollment_key]
      @lecture.participating_students.each do | student |
        @lecture.leave_lecture(student)
      end
    end
    if @lecture.update(lecture_params)
      redirect_to course_lecture_path(@course, @lecture), notice: "Lecture was successfully updated."
    else
      render :edit
    end
  end

  # DELETE courses/:course_id/lectures/1
  def destroy
    if @lecture.destroy
      redirect_to course_path, notice: "Lecture was successfully destroyed."
    end
  end

  # GET courses/:course_id/lectures/current
  def current
    if current_user.is_student?
      @lectures = Lecture.where(course_id: @course.id).active
    else
      redirect_to root_path, alert: "Only Students can access this site."
    end
  end

  def start_lecture
    if @lecture.status != "ended"
      @lecture.set_active
      @lecture.save
      redirect_to course_lecture_path(@course, @lecture)
    else
      redirect_to course_lecture_path(@course, @lecture), alert: "Can't restart an ended lecture."
    end
  end

  def join_lecture
    if params[:lecture].present?
      key = params[:lecture][:enrollment_key]
    end

    if key == @lecture.enrollment_key || !@lecture.enrollment_key_present?
      @lecture.join_lecture(current_user)
      @lecture.save
      current_user.save
      redirect_to course_lecture_path(@course, @lecture), notice: "You successfully joined the lecture."
    else
      redirect_to course_path(@course), alert: "You inserted the wrong key!"
    end
  end

  def leave_lecture
    @lecture.leave_lecture(current_user)
    redirect_to course_lecture_path(@course, @lecture), notice: "You successfully left the lecture."
  end

  def end_lecture
    @lecture.set_inactive
    @lecture.save
    redirect_to course_lecture_path(@course, @lecture), notice: "You successfully ended the lecture."
  end

  # PUT /lectures/:id/comprehension
  def update_comprehension_stamp
    stamp = LectureComprehensionStamp.where(lecture_id: @lecture.id, user_id: current_user.id)
    if stamp.size > 0
      stamp.update_all(status: params[:status], updated_at: DateTime.now)
      stamp.first.broadcast_update
    else
      stamp = LectureComprehensionStamp.create(user: current_user, status: params[:status], lecture: @lecture)
      stamp.broadcast_update
    end
    @lecture.broadcast_comprehension_status
  end

  def get_comprehension
    if current_user.is_student
      stamp = @lecture.lecture_comprehension_stamps.where(user: current_user).max { |a, b| a.timestamp <=> b.timestamp }
      if stamp
        if stamp.timestamp <= Time.now - LectureComprehensionStamp.seconds_till_comp_timeout
          data = { status: -1, last_update: stamp.timestamp }
        else
          data = { status: stamp.status, last_update: stamp.timestamp }
        end
      else
        data = { status: -1, last_update: nil }
      end
    else
      data = @lecture.get_comprehension_status
    end

    render json: data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      @lecture = Lecture.find(params[:id])
    end

    def validate_lecture_owner
      if @lecture.lecturer != current_user
        redirect_to course_path(@course), alert: "You can only access your own lectures."
      end
    end

    def validate_joined_user_or_owner
      isStudent = current_user.is_student
      isJoinedStudent = @lecture.participating_students.include?(current_user)
      isLectureOwner = @lecture.lecturer == current_user
      if isStudent && !isJoinedStudent
        redirect_to course_path(@course), alert: "You must join a lecture before you can view it."
      elsif !isStudent && !isLectureOwner
        redirect_to course_path(@course), alert: "You can only access your own lectures."
      end
    end

    def require_student
      if !current_user.is_student
        redirect_to course_path(@course), alert: "Only students can join a lecture."
      end
    end

    def lecture_params
      params.require(:lecture).permit(:name, :enrollment_key, :status, :polls_enabled, :questions_enabled, :description, :date, :start_time, :end_time)
    end

    def require_lecturer
      if current_user.is_student?
        redirect_to course_path(@course), alert: "You can't access this site as a student."
      end
    end

    def validate_course_creator
      if @course.creator != current_user
        redirect_to @course, alert: "You can only access your own courses."
      end
    end

    def get_course
      @course = Course.find(params[:course_id])
    end
end
