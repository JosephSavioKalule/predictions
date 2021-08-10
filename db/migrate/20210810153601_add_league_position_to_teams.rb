class AddLeaguePositionToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :league_position, :integer
  end
end
