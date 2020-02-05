class ChangeUserLoginToNickname < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :login, :nickname
  end
end
