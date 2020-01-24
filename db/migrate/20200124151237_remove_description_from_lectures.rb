class RemoveDescriptionFromLectures < ActiveRecord::Migration[5.2]
  def change
    remove_column :lectures, :description, :string
  end
end
