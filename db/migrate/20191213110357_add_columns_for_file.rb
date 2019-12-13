class AddColumnsForFile < ActiveRecord::Migration[5.2]
  def change
    remove_column :uploaded_files, :file
    add_column :uploaded_files, :filename, :string
    add_column :uploaded_files, :content_type, :string
    add_column :uploaded_files, :data, :binary
  end
end
