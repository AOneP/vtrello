class AddPositionToLists < ActiveRecord::Migration[6.0]
  def change
    add_column :lists, :position, :integer, null: false
  end
end
