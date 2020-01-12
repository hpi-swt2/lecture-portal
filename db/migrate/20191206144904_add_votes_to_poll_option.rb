class AddVotesToPollOption < ActiveRecord::Migration[5.2]
  def change
    add_column :poll_options, :votes, :integer, null: false, default: 0
  end
end
