class AddTargetIdToTokens < ActiveRecord::Migration[6.0]
  def change
    add_column :tokens, :target_id, :integer, index: true
  end
end
