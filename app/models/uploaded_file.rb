class UploadedFile < ApplicationRecord
  belongs_to :allowsUpload, polymorphic: true
end
