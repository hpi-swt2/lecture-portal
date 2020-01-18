class AddDefaultsToLecture < ActiveRecord::Migration[5.2]
  def change
    change_column_default :lectures, :questions_enabled, true
    change_column_default :lectures, :polls_enabled, true
    change_column_default :lectures, :status, "created"
  end
end
