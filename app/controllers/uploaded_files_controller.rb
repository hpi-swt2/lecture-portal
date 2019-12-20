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
    @uploaded_file = uploaded_file_params["attachment"]
    if @uploaded_file.nil? || !(@uploaded_file.is_a? ActionDispatch::Http::UploadedFile)
      render :new
    else
      filename = @uploaded_file.original_filename
      content_type = @uploaded_file.content_type
      data = @uploaded_file.read
      lecture_id = uploaded_file_params["lecture"]
      unless Lecture.exists?(lecture_id)
        render :new
        return
      end
      lecture = Lecture.find(lecture_id)
      @uploaded_file = UploadedFile.create(filename: filename, content_type: content_type, data: data, allowsUpload: lecture)
      add_type_to_file file:@uploaded_file, type: uploaded_file_params["uploadedFileType"]
      if @uploaded_file.save
        redirect_to (uploaded_files_url), notice: "Uploaded file was successfully saved."
      else
        render :new
      end
    end
  end


  private
    # Only allow a trusted parameter "white list" through.
    def uploaded_file_params
      params.require(:uploaded_file).permit(:attachment, :lecture, :uploadedFileType)
    end

    def add_type_to_file(file:UploadedFile,type:String)
      if type == "Notes"
        file.Notes!
      end
      if type == "Summary"
        file.Summary!
      end
      if type == "Lecture_Slides"
        file.Lecture_Slides!
      end
      if type == "Lecture_Material"
        file.Lecture_Material!
      end

    end
end
