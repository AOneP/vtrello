class CreateTodopoints < ActiveRecord::Migration[6.0]
  def change
    create_table :todopoints do |t|
      t.string :title
      t.boolean :done, default: false
      t.integer :todo_type

      t.timestamps
    end
  end
end
