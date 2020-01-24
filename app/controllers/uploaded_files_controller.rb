class UploadedFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_lecture
  before_action :get_course
  before_action :validate_destroy_rights, only: [:destroy]
  # GET /courses/:course_id/lectures/:lecture_id/uploaded_files
  def index
    if @lecture
      @uploaded_files = UploadedFile.where(allowsUpload_id: @lecture.id)
    else
      @uploaded_files = UploadedFile.where(allowsUpload_id: @course.id)
    end
  end

  # GET /courses/:course_id/lectures/:lecture_id/uploaded_files/new
  def new
    @uploaded_file = UploadedFile.new
    @uploaded_file.author = current_user
    # students are not allowed to upload lecture material
    if @lecture && current_user.is_student
      redirect_to(course_lecture_path(@course, @lecture), notice: "You are not allowed to upload lecture material.")
    else
      if @lecture
        @model =  [@course, @lecture, @uploaded_file]
      else
        @model =  [@course, @uploaded_file]
      end
    end
  end


  # DELETE /courses/:course_id/lectures/:lecture_id/uploaded_files/1
  def destroy
    @uploaded_file.destroy
    if @lecture
      redirect_to course_lecture_path(@course, @lecture), notice: "File was successfully deleted."
    else
      redirect_to course_path(@course), notice: "File was successfully deleted."
    end
  end

  # POST /courses/:course_id/lectures/:lecture_id/uploaded_files
  def create
    uploaded_file = uploaded_file_params["attachment"]
    if uploaded_file.nil? || !(uploaded_file.is_a? ActionDispatch::Http::UploadedFile)
      filename = nil
      content_type = nil
      data = nil
    else
      filename = uploaded_file.original_filename
      content_type = uploaded_file.content_type
      data = uploaded_file.read
    end
    is_link = !uploaded_file_params["link"].blank?
    if is_link
      data = uploaded_file_params["link"]
    end
    # we might be under both
    allows_upload = @course
    if @lecture
      allows_upload = @lecture
    end
    @uploaded_file = UploadedFile.create(filename: filename, content_type: content_type, data: data, allowsUpload: allows_upload, isLink: is_link, author: current_user)
    if @uploaded_file.save
      if @lecture
        redirect_to (course_lecture_path(@course, @lecture)), notice: "Uploaded file was successfully saved."
      else
        redirect_to course_path(@course), notice: "Uploaded file was successfully saved."
      end
    else
      render :new
    end
  end

  # GET /courses/:course_id/lectures/:lecture_id/uploaded_files/:id
  def show
    file = UploadedFile.find(params[:id])
    send_data file.data, filename: file.filename, type: file.content_type, disposition: "attachment"
  end


  private
    # Only allow a trusted parameter "white list" through.
    def uploaded_file_params
      params.require(:uploaded_file).permit(:attachment, :lecture, :link)
    end

    def validate_destroy_rights
      @uploaded_file = UploadedFile.find(params[:id])
      # since students can't upload lecture material, they can't delete it either
      owner = current_user == @uploaded_file.author
      course_file_and_course_owner = (@uploaded_file.allowsUpload.class == Course) && (@uploaded_file.allowsUpload.creator_id == current_user.id)
      lecture_file_and_lecture_owner = (@uploaded_file.allowsUpload.class == Lecture) && (@uploaded_file.allowsUpload.lecturer_id == current_user.id)
      unless owner || course_file_and_course_owner || lecture_file_and_lecture_owner
        if @lecture
          redirect_to (course_path(@course)), notice: "You can't delete this file."
        else
          redirect_to (course_lecture_path(@course, @lecture)), notice: "You can't delete this file."
        end
      end
    end

    def get_course
      @course = Course.find(params[:course_id])
      end
    def get_lecture
      # if we are under /courses, there is no lecture id
      if params[:lecture_id]
        @lecture = Lecture.find(params[:lecture_id])
      else
        @lecture = nil
      end
    end
end
