class ChangeIsActiveDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :polls, :is_active, true
  end
end
