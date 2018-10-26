class PredictionsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :new, :create, :update, :destroy]
  before_action :set_prediction, only: [:show, :edit, :update, :destroy]
  before_action :set_match, only: [:show, :edit, :new, :create, :update, :destroy]
  before_action :valid_match, only: [:create, :update]
  before_action :future_match, only: [:new, :create, :edit, :update]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    if current_user.id != params[:user_id].to_i
      @old_match_ids = Match.where("match_date_time < ?", 1.hour.from_now).pluck(:id)
      @user = User.find(params[:user_id])
      @predictions = @user.predictions.where("match_id in (?)", @old_match_ids).order(created_at: :desc).paginate(page: params[:page])
    else
      @user = current_user
      @predictions = @user.predictions.order(created_at: :desc).paginate(page: params[:page])
    end
  end

  def show
    @match = @prediction.match
    @user = current_user
  end
  
  def new
    @match = Match.find(params[:match_id])
    @prediction = @match.predictions.build
  end
  
  def create
    @prediction = @match.predictions.build(prediction_params)
    if @prediction.save
      flash[:success] = 'Your prediction has been saved!'
    else
      flash[:danger] = 'Your prediction was not saved!'
    end
    redirect_to user_predictions_path(current_user)
  end
  
  def edit
    @match = Match.find(@prediction.match_id)
  end
  
  def update
    if @prediction.update_attributes(prediction_params)
      flash[:success] = "Prediction updated!"
      redirect_to league_match_path(@prediction.match.league, @prediction.match)
    else
      render 'edit'
    end
  end
  
  def destroy
    @prediction.destroy
    flash[:success] = "Prediction deleted"
    redirect_to user_predictions_path current_user
  end
  
  private
    def prediction_params
      params.require(:prediction).permit(:home_goals, :away_goals, :match_id, :user_id)
    end
    
    def set_prediction
      if Prediction.where("id=?",params[:id]).count == 0
        flash[:danger] = 'Prediction not found'
        redirect_to root_path and return
      end
      @prediction = Prediction.find(params[:id])
    end
    
    def set_match
      if params[:match_id]
        @match = Match.find(params[:match_id])
      else
        @match = Match.find(@prediction.match_id)
      end
    end
    
    # before checks:
    def valid_match
      redirect_to league_matches_path(params[:league_id]) and return unless !!@match
    end
    
    def future_match
      if @match.match_date_time < 1.hour.from_now
        flash[:warning] = 'Match no longer available for prediction'
        if params[:league_id]
          redirect_to league_matches_path(params[:league_id])
        else
          redirect_to root_path
        end
      end
    end
    
    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
