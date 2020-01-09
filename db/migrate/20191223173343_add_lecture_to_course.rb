class AddLectureToCourse < ActiveRecord::Migration[5.2]
  def change
    add_reference :courses, :lecture, foreign_key: true
  end
end
