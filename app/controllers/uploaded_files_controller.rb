class UploadedFilesController < ApplicationController
  before_action :authenticate_user!

  # GET /uploaded_files
  def index
    @uploaded_files = UploadedFile.all
  end

  # GET /uploaded_files/new
  def new
    @uploaded_file = UploadedFile.new
    @uploaded_file.author = current_user
  end

  # POST /uploaded_files
  def create
    file = uploaded_file_params["attachment"]
    if file.nil? || !(file.is_a? ActionDispatch::Http::UploadedFile)
      render :new
    else
      filename = file.original_filename
      content_type = file.content_type
      data = file.read
      lecture_id = uploaded_file_params["lecture"]
      unless Lecture.exists?(lecture_id)
        render :new
        return
      end
      lecture = Lecture.find(lecture_id)
      file = UploadedFile.create(filename: filename, content_type: content_type, data: data, allowsUpload: lecture, author: current_user)
      if file.save
        redirect_to (uploaded_files_url), notice: "Uploaded file was successfully saved."
      else
        render :new
      end
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
end
