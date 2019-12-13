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
    file = params["uploaded_file"]["attachment"]
    if file.nil? || !(file.is_a? ActionDispatch::Http::UploadedFile)
      render :new
    else
      filename = file.original_filename
      content_type = file.content_type
      data = file.read
      lecture_id = params["uploaded_file"]["lecture"]
      unless Lecture.exists?(lecture_id)
        render :new
        return
      end
      lecture = Lecture.find(lecture_id)
      file = UploadedFile.create(filename: filename, content_type: content_type, data: data, allowsUpload: lecture)
      if file.save
        redirect_to (uploaded_files_url), notice: 'Uploaded file was successfully created.'
      else
        render :new
      end
    end
  end


  private
    # Only allow a trusted parameter "white list" through.
    def uploaded_file_params
      params.require(:uploaded_file).permit(:content_type, :filename, :data)
    end
end
