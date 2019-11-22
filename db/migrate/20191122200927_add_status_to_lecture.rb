class AddStatusToLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :status, :string, default: "created"
  end
end
