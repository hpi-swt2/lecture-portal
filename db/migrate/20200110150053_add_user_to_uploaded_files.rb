class AddUserToUploadedFiles < ActiveRecord::Migration[5.2]
  def change
    add_reference :uploaded_files, :author, foreign_key: { to_table: "users" }, index: true
  end
end
