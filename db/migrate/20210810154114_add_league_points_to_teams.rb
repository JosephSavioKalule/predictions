class AddLeaguePointsToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :league_points, :integer
  end
end
