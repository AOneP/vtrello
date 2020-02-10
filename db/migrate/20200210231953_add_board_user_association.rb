class AddBoardUserAssociation < ActiveRecord::Migration[6.0]
  def change
    change_table :boards do |t|
      t.belongs_to :user
    end 
  end
end
