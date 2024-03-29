class MatchesController < ApplicationController
  before_action :find_match, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :new, :update, :create, :destroy]
  before_action :admin_user, only: [:edit, :new, :update, :create, :destroy]
  before_action :not_yet_finalized, only: [:edit, :update]
  
  def index
    @league = League.find(params[:league_id])
    @future_matches = @league.matches.where("match_date_time > ?", 1.second.from_now).order(:match_date_time)
    @old_matches = @league.matches.where("match_date_time <= ?", 1.second.from_now).order(match_date_time: :desc)
  end
  
  def show
    @home_team = Team.find(@match.home_team_id)
    @away_team = Team.find(@match.away_team_id)
    
    @home_team_form = @home_team.form(@home_team.past_matches)
    @away_team_form = @away_team.form(@away_team.past_matches)
    
    if logged_in?
      if Prediction.where("match_id=? and user_id=?", @match.id, current_user).count == 1
        @prediction = Prediction.where("match_id=? and user_id=?", @match.id, current_user).first
      end
    end
  end
  
  def new
    @league = League.find(params[:league_id])
    @match = @league.matches.build
  end
  
  def create
    @league = League.find(params[:league_id])
    @match = @league.matches.build(match_params)
    @match.home_goals = nil
    @match.away_goals = nil
    if @match.save
      flash[:success] = "Match successfully created!"
      redirect_to league_match_path(@league, @match)
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @match.match_date_time < 2.hours.ago
      # match ended
      if @match.update_attributes(match_params)
        # update predictor points
        # 1 point for everyone:
        # Prediction.where("match_id=?", @match.id)
        @match.predictions.each do |prediction|
          prediction.user.predictors.where("league_id=?", @match.league_id).first.increment!(:games_played)
          prediction.user.predictors.where("league_id=?", @match.league_id).first.increment!(:points)
        end
        
        if @match.home_goals > @match.away_goals
          # home victory
          @match.predictions.where("home_goals > away_goals").each do |prediction|
            prediction.user.predictors.where("league_id=?", @match.league_id).first.increment!(:points, 2)
          end
        else
          if @match.home_goals < @match.away_goals
            # away victory
            @match.predictions.where("home_goals < away_goals").each do |prediction|
              prediction.user.predictors.where("league_id=?", @match.league_id).first.increment!(:points, 2)
            end
          else
            # draw
            @match.predictions.where("home_goals = away_goals").each do |prediction|
              prediction.user.predictors.where("league_id=?", @match.league_id).first.increment!(:points, 2)
            end
          end
        end
        # 2 extra points for exact scores:
        @match.predictions.where("home_goals = ? AND away_goals = ?", @match.home_goals, @match.away_goals).each do |prediction|
          prediction.user.predictors.where("league_id=?", @match.league_id).first.increment!(:points, 2)
        end
        
        flash[:success] = "Match updated. There were #{@match.predictions.count} predictions."
          
        redirect_to league_match_path(@match.league, @match)
      else
        render 'edit'
      end
    else
      # not ended
      if @match.update_column(:match_date_time, match_params[:match_date_time])
        flash[:success] = "Match time updated"
        redirect_to league_match_path(@match.league, @match)
      else
        render 'edit'
      end
    end
  end

  def destroy
    league = @match.league
    # remove all predictions
    predictions = @match.predictions
    predictions.each do |prediction|
      prediction.delete
    end
    # now delete match
    @match.destroy
    flash[:success] = "Match has been deleted"
    redirect_to league_matches_path(league)
  end

  private
    
    def find_match
      if Match.where("id=?", params[:id]).count == 0
        flash[:danger] = 'Invalid match!'
        redirect_to leagues_path and return
      end
      @match = Match.find(params[:id])
    end
    
    def not_yet_finalized
      redirect_to league_matches_path(@match.league, @match) and return unless !@match.home_goals
    end
    
    def match_params
      params.require(:match).permit(:league_id, :home_team_id, :away_team_id,
                                    :match_date_time, :home_goals, :away_goals)
    end
end
