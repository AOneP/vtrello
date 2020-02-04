class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.string :title
      t.boolean :done, default: false

      t.belongs_to :board

      t.timestamps
    end
  end
end
