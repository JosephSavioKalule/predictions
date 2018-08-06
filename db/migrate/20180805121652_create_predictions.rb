class CreatePredictions < ActiveRecord::Migration[5.1]
  def change
    create_table :predictions do |t|
      t.integer :home_goals
      t.integer :away_goals
      t.references :match, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :predictions, [:user_id, :created_at]
  end
end
