class TeamsController < ApplicationController
  def index
    @teams = Team.all.order(:name)
  end

  def show
    @team = Team.find(params[:id])
  end
end
