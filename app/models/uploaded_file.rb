class UploadedFile < ApplicationRecord
  belongs_to :allowsUpload, polymorphic: true
  belongs_to :author, class_name: :User
end
