class CreateJoinTableStudentLecture < ActiveRecord::Migration[5.2]
  def change
    create_join_table :lectures, :users do |t|
      t.index [:lecture_id, :user_id]
      t.index [:user_id, :lecture_id]
    end
  end
end
