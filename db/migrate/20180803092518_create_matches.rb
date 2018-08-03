class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.references :league, foreign_key: true
      t.references :home_team
      t.references :away_team
      t.datetime :match_date_time
      t.integer :home_goals
      t.integer :away_goals

      t.timestamps
    end
  end
end
