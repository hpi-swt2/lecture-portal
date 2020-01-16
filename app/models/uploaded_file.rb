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
end
