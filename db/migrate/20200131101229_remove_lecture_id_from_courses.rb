class RemoveLectureIdFromCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :courses, :lecture_id, :integer
  end
end
