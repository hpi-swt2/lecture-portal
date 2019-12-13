class AddFileToUploadedFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :uploaded_files, :file, :string
  end
end
