class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.integer :board_id
      t.integer :user_id

      t.timestamps
    end
  end
end
