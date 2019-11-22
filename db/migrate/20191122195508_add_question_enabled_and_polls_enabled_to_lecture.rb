class AddQuestionEnabledAndPollsEnabledToLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :questions_enabled, :boolean, null: false
    add_column :lectures, :polls_enabled, :boolean, null: false
  end
end
