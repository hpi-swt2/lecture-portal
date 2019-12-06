class CreateJoinTableQuestionUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :questions, :users do |t|
      t.index [:question_id, :user_id]
      t.index [:user_id, :question_id]
    end
  end
end
