class AddIsLinkToUploadedFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :uploaded_files, :isLink, :boolean
  end
end
