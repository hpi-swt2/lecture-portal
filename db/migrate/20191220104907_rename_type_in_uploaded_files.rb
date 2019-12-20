class RenameTypeInUploadedFiles < ActiveRecord::Migration[5.2]
  def change
    rename_column :uploaded_files, :type, :uploadedFileType
  end
end
