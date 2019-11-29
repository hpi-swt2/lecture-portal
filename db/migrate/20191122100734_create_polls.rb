class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.string :title
      t.boolean :is_multiselect

      t.timestamps
    end
  end
end
