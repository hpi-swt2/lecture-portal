class ChangeCoursesStatusToString < ActiveRecord::Migration[5.2]
  def change
    change_column :courses, :status, :string
  end
end
