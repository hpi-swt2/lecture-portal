class AddRefsToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :student, foreign_key: { to_table: :users }
    add_reference :answers, :option, foreign_key: { to_table: :poll_options }
    add_reference :answers, :poll, foreign_key: { to_table: :polls }
    end
end
