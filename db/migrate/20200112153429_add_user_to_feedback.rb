class AddUserToFeedback < ActiveRecord::Migration[5.2]
  def change
    add_reference :feedbacks, :user, foreign_key: true
  end
end
