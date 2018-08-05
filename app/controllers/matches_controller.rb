class MatchesController < ApplicationController
  before_action :find_match, only: :show
  
  def index
    @league = League.find(params[:league_id])
    @matches = @league.matches
  end
  
  def show
  end
  
  private
    
    def find_match
      @match = Match.find(params[:id])
    end
end
