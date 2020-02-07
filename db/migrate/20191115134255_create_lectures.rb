class CreateLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :lectures do |t|
      t.string :name
      t.string :description, default: ""
      t.string :enrollment_key
      t.timestamps
    end
  end
end
