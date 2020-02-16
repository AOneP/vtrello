class AddTypeToTokens < ActiveRecord::Migration[6.0]
  def change
    add_column :tokens, :type, :string, null: false, index: true
  end
end
