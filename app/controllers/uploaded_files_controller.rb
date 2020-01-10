class UploadedFilesController < ApplicationController
  before_action :authenticate_user!

  # GET /uploaded_files
  def index
    @uploaded_files = UploadedFile.all
  end

  # GET /uploaded_files/new
  def new
    @uploaded_file = UploadedFile.new
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
    params.require(:uploaded_file).permit(:attachment, :lecture, :link)
  end
end
