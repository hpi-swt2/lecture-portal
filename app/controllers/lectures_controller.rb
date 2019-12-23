class LecturesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_course
  before_action :set_lecture, only: [:show, :edit, :update, :destroy, :start_lecture, :end_lecture, :join_lecture]
  before_action :validate_lecture_owner, only: [:edit, :update, :destroy, :start_lecture, :end_lecture]
  before_action :validate_joined_user_or_owner, only: [:show]
  #before_action :require_lecturer, except: [:current, :join_lecture, :show]
  before_action :require_student, only: [:join_lecture]

  # GET /lectures
  def index
    @lectures = Lecture.where(lecturer: current_user)
  end

  # GET /lectures/1
  def show
    @current_user = current_user
  end

  # GET /lectures/new
  def new
    if current_user.is_student
      redirect_to course_lecture_path(@lecture), notice: "You are a student. You can not create polls."
    else
      @lecture = @course.lectures.build
      @lecture.lecturer = current_user
    end
  end

  # GET /lectures/1/edit
  def edit
  end

  # POST /lectures
  def create
    @lecture = @course.lectures.build(lecture_params)
    @lecture.lecturer = current_user
    if @lecture.save
      redirect_to course_lectures_url, notice: "Lecture was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /lectures/1
  def update
    if @lecture.update(lecture_params)
      redirect_to @lecture, notice: "Lecture was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /lectures/1
  def destroy
    if @lecture.destroy
      redirect_to lectures_url, notice: "Lecture was successfully destroyed."
    end
  end

  # GET /lectures/current
  def current
    if current_user.is_student?
      @lectures = Lecture.active
    else
      redirect_to root_path, notice: "Only Students can access this site."
    end
  end

  def start_lecture
    @lecture.set_active
    @lecture.save
    redirect_to lecture_path(@lecture)
  end

  def join_lecture
    @lecture.join_lecture(current_user)
    @lecture.save
    current_user.save
    redirect_to @lecture, notice: "You successfully joined the lecture."
  end

  def end_lecture
    @lecture.set_inactive
    @lecture.save
    redirect_to lecture_path(@lecture), notice: "You successfully ended the lecture."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      @lecture = Lecture.find(params[:id])
    end

    def validate_lecture_owner
      if @lecture.lecturer != current_user
        redirect_to lectures_url, notice: "You can only access your own lectures."
      end
    end

    def validate_joined_user_or_owner
      isStudent = current_user.is_student
      isJoinedStudent = @lecture.participating_students.include?(current_user)
      isLectureOwner = @lecture.lecturer == current_user
      if isStudent && !isJoinedStudent
        redirect_to current_lectures_url, notice: "You must join a lecture before you can view it."
      elsif !isStudent && !isLectureOwner
        redirect_to lectures_url, notice: "You can only access your own lectures."
      end
    end

    def require_student
      if !current_user.is_student
        redirect_to lectures_url, notice: "Only students can join a lecture."
      end
    end

    # Only allow a trusted parameter "white list" through.
    def lecture_params
      params.require(:lecture).permit(:name, :enrollment_key, :status, :polls_enabled, :questions_enabled)
    end

    def require_lecturer
      if current_user.is_student?
        redirect_to current_lectures_url, notice: "You can't access this site as a student."
      end
    end

  def get_course
    @course = Course.find(params[:course_id])
  end
end
