class RenameIsActiveOfPolls < ActiveRecord::Migration[5.2]
  def change
    rename_column :polls, :is_active, :status
  end
end
