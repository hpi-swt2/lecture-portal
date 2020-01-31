class RemoveIsActiveFromPolls < ActiveRecord::Migration[5.2]
  def change
    remove_column :polls, :is_active, :boolean
  end
end
