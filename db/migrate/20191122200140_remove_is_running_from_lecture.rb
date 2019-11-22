class RemoveIsRunningFromLecture < ActiveRecord::Migration[5.2]
  def change
    remove_column :lectures, :is_running, :boolean
  end
end
