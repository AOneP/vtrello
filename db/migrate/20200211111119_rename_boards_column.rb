class RenameBoardsColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :boards, :user_id, :owner_id
  end
end
