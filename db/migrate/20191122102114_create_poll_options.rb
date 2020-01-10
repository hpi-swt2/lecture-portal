class CreatePollOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :poll_options do |t|
      t.text :description
      t.references :poll, foreign_key: true

      t.timestamps
    end
  end
end
