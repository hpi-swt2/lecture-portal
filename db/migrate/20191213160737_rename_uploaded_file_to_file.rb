class RenameUploadedFileToFile < ActiveRecord::Migration[5.2]
  def change
    rename_table :uploaded_files, :files
  end
end
