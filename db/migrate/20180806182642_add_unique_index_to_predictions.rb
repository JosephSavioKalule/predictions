class AddUniqueIndexToPredictions < ActiveRecord::Migration[5.1]
  def change
    add_index :predictions, [:user_id, :match_id], unique: true
  end
end
