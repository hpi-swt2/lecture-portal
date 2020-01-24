class AddFeedbackToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :feedback, foreign_key: true
  end
end
