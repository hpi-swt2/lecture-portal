class AddQuestionsEnabledToLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :questions_enabled, :boolean
    add_column :lectures, :polls_enabled, :boolean
    add_column :lectures, :status, :string
  end
end
