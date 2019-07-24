class TeamsController < ApplicationController
  def index
    @teams = Team.where("league_id>4").order(:name)
  end

  def show
    @team = Team.find(params[:id])
    @matches = @team.past_matches
    @form = @team.form(@matches)
  end
end
