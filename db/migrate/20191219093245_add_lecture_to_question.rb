class AddLectureToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :lecture, foreign_key: true
  end
end
