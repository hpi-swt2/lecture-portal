class UploadedFile < ApplicationRecord
  belongs_to :allowsUpload, polymorphic: true

  def create_file(filename, content_type, data)
    self.content_type =content_type
    self.filename =filename
    self.data = data
  end
end
