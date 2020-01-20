class AddHashIdToCalendars < ActiveRecord::Migration[5.2]
  def change
    add_column :calendars, :hash_id, :string
  end
end
