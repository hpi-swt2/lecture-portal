class AddTypeToUploadedFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :uploaded_files, :type, :string
  end
end
