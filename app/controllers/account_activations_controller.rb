class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      user.predictors.build(league_id:1).save!
      user.predictors.build(league_id:2).save!
      user.predictors.build(league_id:3).save!
      user.predictors.build(league_id:4).save!
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
