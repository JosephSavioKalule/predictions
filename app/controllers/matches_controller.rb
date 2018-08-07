class MatchesController < ApplicationController
  before_action :find_match, only: :show
  
  def index
    @league = League.find(params[:league_id])
    @matches = @league.matches
  end
  
  def show
    if logged_in?
      if Prediction.where("match_id=? and user_id=?", @match.id, current_user).count == 1
        @prediction = Prediction.where("match_id=? and user_id=?", @match.id, current_user).first
      else
        @user = current_user
      end
    end
  end
  
  private
    
    def find_match
      if Match.where("id=?", params[:id]).count == 0
        flash[:danger] = 'Invalid match!'
        redirect_to leagues_path and return
      end
      @match = Match.find(params[:id])
    end
end
