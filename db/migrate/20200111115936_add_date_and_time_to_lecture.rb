class AddDateAndTimeToLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :date, :date
    add_column :lectures, :start_time, :time
    add_column :lectures, :end_time, :time
  end
end
