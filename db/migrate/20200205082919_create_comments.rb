class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|

      t.string :author
      t.string :body
      t.belongs_to :todopoint

      t.timestamps
    end
  end
end
