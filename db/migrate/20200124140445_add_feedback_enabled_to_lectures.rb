class AddFeedbackEnabledToLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :feedback_enabled, :boolean, default: true
  end
end
