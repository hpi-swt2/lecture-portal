class ChangeIsLinkDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :uploaded_files, :isLink, false
  end
end
