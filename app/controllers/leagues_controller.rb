class LeaguesController < ApplicationController
  before_action :logged_in_user, only: [:rankings]
  
  def index
    @leagues = Season.find(2).leagues
  end

  def show
    @league = League.find(params[:id])
    @teams = @league.teams.order(:name)
    @recent_matches = @league.matches.where("match_date_time < ?", 1.minute.ago).order(match_date_time: :desc).limit(5)
  end
  
  def table
  end
  
  def rankings
    @league = League.find(params[:id])
    @predictors = @league.predictors.order(points: :desc).paginate(page: params[:page])
  end
end
