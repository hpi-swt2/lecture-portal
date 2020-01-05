class AddCreatorReferenceToCourse < ActiveRecord::Migration[5.2]
  def change
    add_reference :courses, :creator, foreign_key: { to_table: :users }
  end
end
