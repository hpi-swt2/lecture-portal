class AddLecturerRefToLecture < ActiveRecord::Migration[5.2]
  def change
    add_reference :lectures, :lecturer, foreign_key: { to_table: :user }  end
end
