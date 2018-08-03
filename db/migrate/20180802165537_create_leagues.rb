class CreateLeagues < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues do |t|
      t.string :name
      t.references :country, foreign_key: true
      t.references :season, foreign_key: true

      t.timestamps
    end
  end
end
