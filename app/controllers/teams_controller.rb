class TeamsController < ApplicationController
  def index
    @teams = Team.all.order(:name)
  end

  def show
    @team = Team.find(params[:id])
    @matches = Match.where("home_team_id=? or away_team_id=?", @team.id, @team.id)
  end
end
