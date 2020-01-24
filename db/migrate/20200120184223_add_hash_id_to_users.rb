class AddHashIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :hash_id, :string
  end
end
