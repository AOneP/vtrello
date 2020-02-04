class CreateTodopoints < ActiveRecord::Migration[6.0]
  def change
    create_table :todopoints do |t|

      t.string :body
      t.boolean :done, default: false
      t.integer :position
      t.belongs_to :list
      
      t.timestamps
    end
  end
end
