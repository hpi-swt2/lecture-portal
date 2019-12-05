class LecturesController < ApplicationController
  before_action :set_lecture, only: [:show, :edit, :update, :destroy]

  # GET /lectures
  def index
    @lectures = Lecture.all
    # TODO if user is lecturer render index
  end

  # GET /lectures/1
  def show
  end

  # GET /lectures/new
  def new
    if !current_user.is_student?
      @lecture = Lecture.new
      @lecture.lecturer = current_user
    else
      redirect_to lectures_url, notice: "You are a student! You can not create a lecture :("
    end
  end

  # GET /lectures/1/edit
  def edit
    if current_user.is_student?
      redirect_to lectures_url, notice: "You are a student! You can not edit a lecture :("
    end
    if @lecture.lecturer != current_user
      redirect_to lectures_url, notice: "You can only edit your own lectures"
    end
  end

  # POST /lectures
  def create
    if current_user.is_student?
      redirect_to lectures_url, notice: "You are a student! You can not create a lecture :("
    else
      @lecture = Lecture.new(lecture_params)
      @lecture.lecturer = current_user
      if @lecture.save
        redirect_to @lecture, notice: "Lecture was successfully created."
      else
        render :new
      end
    end
  end

  # PATCH/PUT /lectures/1
  def update
    if current_user.is_student?
      redirect_to lectures_url, notice: "You are a student! You can not update a lecture :("
    elsif @lecture.lecturer != current_user
      redirect_to lectures_url, notice: "You can only update your own lectures"
    elsif @lecture.update(lecture_params)
      redirect_to @lecture, notice: "Lecture was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /lectures/1
  def destroy
    if current_user.is_student?
      redirect_to lectures_url, notice: "You are a student! You can not delete a lecture :("
    else
      @lecture.destroy
      redirect_to lectures_url, notice: "Lecture was successfully destroyed."
    end
  end
  # GET /lectures/current
  def current
    if current_user.is_student?
      @lectures = Lecture.active
    else
      redirect_to root_path
    end
  end

  def start_lecture
    # TODO make sure user is lecturer
    id = params["lecture"]
    lecture = Lecture.find(id)
    lecture.set_active
    lecture.save
    redirect_to lecture_path(lecture)
    end

  def end_lecture
    # TODO make sure user is lecturer
    id = params["lecture"]
    lecture = Lecture.find(id)
    lecture.set_inactive
    lecture.save
    redirect_to lecture_path(lecture)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      @lecture = Lecture.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lecture_params
      params.require(:lecture).permit(:name, :enrollment_key, :status, :polls_enabled, :questions_enabled)
    end
end
