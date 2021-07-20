class LeaguesController < ApplicationController
  before_action :logged_in_user, only: [:rankings, :edit, :update]
  before_action :admin_user, only: [:edit, :update]

  def index
    @season = Season.last
    @leagues = @season.leagues
  end

  def show
    @league = League.find(params[:id])
    @teams = @league.teams.order(:name)
    @recent_matches = @league.matches.where("match_date_time < ?", 1.minute.ago).order(match_date_time: :desc).limit(5)
  end

  def edit
    @league = League.find(params[:id])
  end

  def update
    @league = League.find(params[:id])
    if @league.update(league_update_params)
      flash[:success] = "League updated successfully!"
      redirect_to @league
    else
      render 'edit'
    end
  end

  def table
  end

  def rankings
    @league = League.find(params[:id])
    @predictors = @league.predictors.order(points: :desc).paginate(page: params[:page])
  end

  private

    def league_update_params
      params.require(:league).permit(:name, :logo_url)
    end
end
