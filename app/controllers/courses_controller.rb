class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  #before_action :validate_owner, only: [:show, :edit]

  # GET /courses
  def index
    @courses = Course.all
  end

  # GET /courses/1
  def show
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
    redirect_to @course, notice: "You successfully joined the lecture."
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
        redirect_to lectures_url, notice: "You can only access your own courses."
      end
    end
end
