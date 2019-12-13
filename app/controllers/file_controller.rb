class FileController < ApplicationController
  before_action :authenticate_user!
  def upload
    file = params["datafile"]
    if file.nil? || !(file.is_a? ActionDispatch::Http::UploadedFile)
      head :bad_request
    else
      filename = file.original_filename
      content_type = file.content_type
      data = file.read
      lecture_id = params["lecture"]
      unless Lecture.exists?(lecture_id)
        head :bad_request
        return
      end
      lecture = Lecture.find(lecture_id)
      file = UploadedFile.create(filename: filename, content_type: content_type, data: data, allowsUpload: lecture)
      if file.save
        head :ok
      else
        head :bad_request
      end
    end
  end
end
