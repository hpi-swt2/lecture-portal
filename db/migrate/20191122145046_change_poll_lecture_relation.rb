class ChangePollLectureRelation < ActiveRecord::Migration[5.2]
  def change
    remove_reference :lectures, :poll, foreign_key: true
    add_reference :polls, :lecture, foreign_key: true
  end
end
