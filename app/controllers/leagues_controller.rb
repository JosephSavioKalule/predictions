class LeaguesController < ApplicationController
  def index
    @leagues = League.all
  end

  def show
    @league = League.find(params[:id])
    @teams = @league.teams.all
    @matches = @league.matches.where("match_date_time < ?", 2.weeks.from_now).order("match_date_time").limit(3)
  end
end
