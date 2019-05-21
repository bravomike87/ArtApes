class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :artworks, :type, :kind
  end
end
