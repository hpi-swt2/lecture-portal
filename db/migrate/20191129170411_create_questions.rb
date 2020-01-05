class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :content
      t.references :author, foreign_key: { to_table: "users" }

      t.timestamps
    end
  end
end
