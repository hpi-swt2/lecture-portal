class AddResolvedToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :resolved, :boolean, null: false, default: false
  end
end
