class UploadedFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_destroy_rights, only: [:destroy]

  # GET /uploaded_files
  def index
    @uploaded_files = UploadedFile.all
  end

  # GET /uploaded_files/new
  def new
    @uploaded_file = UploadedFile.new
    @uploaded_file.author = current_user
  end


  # DELETE /uploaded_files/1
  def destroy
    @uploaded_file.destroy
    if @uploaded_file.allowsUpload.class.name == "Course"
      redirect_to course_path(@uploaded_file.allowsUpload), notice: "File was successfully deleted."
    else
      redirect_to course_lecture_path(@uploaded_file.allowsUpload), notice: "File was successfully deleted."
    end
  end

  # POST /uploaded_files
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
    lecture_id = uploaded_file_params["lecture"]
    if Lecture.exists?(lecture_id)
      lecture = Lecture.find(lecture_id)
    else
      lecture = nil
    end
    is_link = !uploaded_file_params["link"].blank?
    if is_link
      data = uploaded_file_params["link"]
    end
    @uploaded_file = UploadedFile.create(filename: filename, content_type: content_type, data: data, allowsUpload: lecture, isLink: is_link)
    if @uploaded_file.save
      redirect_to (uploaded_files_url), notice: "Uploaded file was successfully saved."
    else
      render :new
    end
  end

  # GET /uploaded_files/:id
  def show
    file = UploadedFile.find(params[:id])
    send_data file.data, filename: file.filename, type: file.content_type, disposition: "attachment"
  end


  private
    # Only allow a trusted parameter "white list" through.
    def uploaded_file_params
      params.require(:uploaded_file).permit(:attachment, :lecture)
    end

    def validate_destroy_rights
      @uploaded_file = UploadedFile.find(params[:id])
      owner = current_user == @uploaded_file.author
      course_file_and_course_owner = (@uploaded_file.allowsUpload.class == Course) && (@uploaded_file.allowsUpload.creator_id == current_user.id)
      lecture_file_and_lecture_owner = (@uploaded_file.allowsUpload.class == Lecture) && (@uploaded_file.allowsUpload.lecturer_id == current_user.id)
      unless owner || course_file_and_course_owner || lecture_file_and_lecture_owner
        redirect_to (uploaded_files_url), notice: "You can't delete this file."
      end
    end
end
