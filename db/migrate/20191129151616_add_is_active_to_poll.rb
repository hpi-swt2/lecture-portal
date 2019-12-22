class AddIsActiveToPoll < ActiveRecord::Migration[5.2]
  def change
    change_column :polls, :is_active, :boolean, null: false, default: true
  end
end
