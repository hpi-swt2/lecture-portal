class AddDefaultStatusToCourses < ActiveRecord::Migration[5.2]
  def change
    change_column_default :courses, :status, "open"
  end
end
