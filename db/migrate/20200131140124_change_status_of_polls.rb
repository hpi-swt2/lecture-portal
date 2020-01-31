class ChangeStatusOfPolls < ActiveRecord::Migration[5.2]
  def change
    change_column :polls, :status, :string
  end
end
