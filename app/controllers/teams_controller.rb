class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :admin_user, only: [:edit, :update]

  def index
    @teams = Team.where("league_id in (?)",
           League.where("season_id=?",Season.last.id).pluck(:id)).order(:name)
  end

  def show
    @team = Team.find(params[:id])
    @past_matches = @team.past_matches
    @future_matches = @team.future_matches
    @ongoing_matches = @team.ongoing_matches
    @form = @team.form(@past_matches)
  end

  def edit
  end

  def update
    if @team.update_attributes(team_update_params)
      flash[:success] = "Team updated"
      redirect_to @team
    else
      render 'edit'
    end
  end

  private

    def set_team
      @team = Team.find(params[:id])
    end

    def team_update_params
      params.require(:team).permit(:name, :logo_url)
    end
end
