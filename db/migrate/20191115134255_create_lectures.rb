class CreateLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :lectures do |t|
      t.string :name
      t.string :enrollment_key
      t.boolean :is_running

      t.timestamps
    end
  end
end
