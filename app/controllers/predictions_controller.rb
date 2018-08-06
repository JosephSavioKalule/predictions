class PredictionsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show]
  
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
    @predictions = @user.predictions
  end

  def show
    @prediction = Prediction.find(params[:id])
    if @prediction
      @match = @prediction.match
    else
      flash[:danger] = 'Prediction not found'
      redirect_to root_path
    end
  end
end
