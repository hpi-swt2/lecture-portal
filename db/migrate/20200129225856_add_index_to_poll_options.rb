class AddIndexToPollOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :poll_options, :index, :number
  end
end
