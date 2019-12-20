class AddDescriptionToLectures < ActiveRecord::Migration[5.2]
  def change
    unless column_exists?(:lectures, :description)
      add_column :lectures, :description, :string, default: ""
    end
  end
end
