class CreatePredictors < ActiveRecord::Migration[5.1]
  def change
    create_table :predictors do |t|
      t.references :user, foreign_key: true
      t.references :league, foreign_key: true
      t.integer :games_played, default: 0
      t.integer :points, default: 0

      t.timestamps
    end
    
    add_index :predictors, [:user_id, :league_id], unique: true
  end
end
