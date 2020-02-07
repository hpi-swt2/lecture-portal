class SaveFileExtensionForUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploaded_files, :extension, :string
  end
end
