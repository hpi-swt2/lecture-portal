class CreateComprehensionStamps < ActiveRecord::Migration[5.2]
  def change
    create_join_table :lectures, :users, table_name: :lecture_comprehension_stamps do |t|
      t.index [:lecture_id, :user_id]
      t.index [:user_id, :lecture_id]
      t.integer :status
      t.timestamps
    end
  end
end
