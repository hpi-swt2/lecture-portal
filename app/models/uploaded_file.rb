class UploadedFile < ApplicationRecord
  belongs_to :allowsUpload, polymorphic: true
  enum uploadedFileType: { Notes: "Notes", Summary: "Summary", Lecture_Slides: "Lecture Slides", Lecture_Material: "Lecture Material" }
  validates :uploadedFileType, inclusion: { in: uploadedFileTypes.keys }
end
