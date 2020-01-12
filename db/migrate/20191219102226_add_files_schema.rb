class AddFilesSchema < ActiveRecord::Migration[5.2]
  def change
    create_table :uploaded_files do |t|
      t.string :content_type
      t.string :filename
      t.binary :data

      t.references :allowsUpload, polymorphic: true

      t.timestamps
    end
  end
end
