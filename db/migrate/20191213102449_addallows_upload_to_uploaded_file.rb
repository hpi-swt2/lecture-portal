class AddallowsUploadToUploadedFile < ActiveRecord::Migration[5.2]
  def up
    change_table :uploaded_files do |t|
      t.references :allowsUpload, polymorphic: true
    end
  end

  def down
    change_table :uploaded_files do |t|
      t.remove_references :allowsUpload, polymorphic: true
    end
  end
end
