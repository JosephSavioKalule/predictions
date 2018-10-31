class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :delete]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    #@users = User.where(activated: true).order(:id).reverse_order.paginate(page: params[:page])
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    if params[:id]
      @user = User.find(params[:id])
      redirect_to root_url and return unless @user.activated?
    else
      @user = current_user
    end
    if @user == current_user
      @urgent_predictions = Match.where("match_date_time > ? and match_date_time < ? and id not in (?)",
            1.hour.from_now, 24.hours.from_now, Prediction.select(:match_id).where("user_id=?",@user.id))
            .order(:match_date_time)
    end
    @num_predictions = @user.predictions.count
    if @num_predictions > 0
      @predictors = @user.predictors
      @total_points = @user.predictors.pluck(:points).sum
      @num_played = @user.predictors.pluck(:games_played).sum
      @success_rate = (100 * (@total_points - @num_played))/(4 * @num_predictions)
    else
      @success_rate = 0
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_update_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def delete
    @user = current_user
    if @user.authenticate(params[:user][:password])
      @user.destroy
      flash[:success] = "Account deleted!"
      redirect_to root_url
    else
      flash[:danger] = "Wrong password"
      redirect_to profile_path
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def user_update_params
      params.require(:user).permit(:name, :password,
                                   :password_confirmation)
    end
    
    # Before filters
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
