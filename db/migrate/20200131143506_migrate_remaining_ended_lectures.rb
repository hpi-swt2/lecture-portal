class MigrateRemainingEndedLectures < ActiveRecord::Migration[5.2]
  def change
    Lecture.connection.execute("UPDATE lectures SET status='archived' WHERE status='ended';")
  end
end
