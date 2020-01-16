class CreateCalendars < ActiveRecord::Migration[5.2]
  def change
    create_table :calendars do |t|
      t.text :ical

      t.timestamps
    end
  end
end
