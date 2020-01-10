class UploadedFile < ApplicationRecord
  belongs_to :allowsUpload, polymorphic: true
  validates :data, presence: true
  # do not validate presence of content type. Unfortunately, rspec can not set it in tests,
  # so validating its presence will break some tests without possibility to fix them.
end
