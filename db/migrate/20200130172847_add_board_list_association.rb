class AddBoardListAssociation < ActiveRecord::Migration[6.0]
  def change
    change_table :lists do |t|
      t.belongs_to :board
    end 
  end
end
