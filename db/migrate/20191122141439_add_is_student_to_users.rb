class AddIsStudentToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_student, :boolean, null: false, default: false
  end
end
