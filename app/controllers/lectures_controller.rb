class LecturesController < ApplicationController
  before_action :set_lecture, only: [:show, :edit, :update, :destroy, :start_lecture, :end_lecture]
  before_action :validtate_lecture_owner, only: [:show, :edit, :update, :destroy, :start_lecture, :end_lecture]
  before_action :authenticate_user!
  before_action :require_lecturer, except: [:current]


  # GET /lectures
  def index
    @lectures = Lecture.where(lecturer: current_user)
  end

  # GET /lectures/1
  def show
  end

  # GET /lectures/new
  def new
    @lecture = Lecture.new
    @lecture.lecturer = current_user
  end

  # GET /lectures/1/edit
  def edit
  end

  # POST /lectures
  def create
    @lecture = Lecture.new(lecture_params)
    @lecture.lecturer = current_user
    if @lecture.save
      redirect_to @lecture, notice: "Lecture was successfully created."
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
      redirect_to root_path
    end
  end

  def start_lecture
    @lecture.set_active
    @lecture.save
    redirect_to lecture_path(@lecture)
    end

  def end_lecture
    @lecture.set_inactive
    @lecture.save
    redirect_to lecture_path(@lecture)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      @lecture = Lecture.find(params[:id])
    end

    def validtate_lecture_owner
      if @lecture.lecturer != current_user
        redirect_to lectures_url, notice: "You can only access your own lectures"
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
end
