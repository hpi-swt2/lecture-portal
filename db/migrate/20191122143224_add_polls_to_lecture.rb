class AddPollsToLecture < ActiveRecord::Migration[5.2]
  def change
    add_reference :lectures, :poll, foreign_key: true
  end
end
