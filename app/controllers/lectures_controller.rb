class LecturesController < ApplicationController
  before_action :set_lecture, only: [:show, :edit, :update, :destroy]

  # GET /lectures
  def index
    @lectures = Lecture.all
  end

  # GET /lectures/1
  def show
  end

  # GET /lectures/new
  def new
    if !current_user.is_student?
      @lecture = Lecture.new
    else
      redirect_to lectures_url, notice: "You are a student! You can not create a lecture :("
    end
  end

  # GET /lectures/1/edit
  def edit
  end

  # POST /lectures
  def create
    @lecture = Lecture.new(lecture_params)

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
    @lecture.destroy
    redirect_to lectures_url, notice: "Lecture was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      @lecture = Lecture.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lecture_params
      params.require(:lecture).permit(:name, :enrollment_key, :is_running)
    end
end
