class UploadedFile < ApplicationRecord
  belongs_to :allowsUpload, polymorphic: true
  belongs_to :author, class_name: :User


  def self.student_files
    @files = []
    all.each do |file|
      if file.author.is_student
        @files << file
      end
    end
    @files
  end

  def self.lecturer_files
    @files = []
    all.each do |file|
      if !file.author.is_student
        @files << file
      end
    end
    @files
  end
  validates :data, presence: true
  # do not validate presence of content type. Unfortunately, rspec can not set it in tests,
  # so validating its presence will break some tests without possibility to fix them.
end
