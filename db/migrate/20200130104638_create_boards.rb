class CreateBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.string :title
      t.string :describe
      t.boolean :archived, default: false
      t.integer :background_color

      t.timestamps
    end
  end
end
