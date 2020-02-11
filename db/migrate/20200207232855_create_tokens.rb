class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.string :value
      t.string :email
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
