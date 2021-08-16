class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      # get league ids for current season
      @league_ids = League.where(season_id: Season.where(start_year: Date.today.year).pluck(:id)).pluck(:id)
      @league_ids.each do |lg_id|
        user.predictors.build(league_id: lg_id).save!
      end
      SettingsBox.create!(user_id: user.id, receive_email: true)
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
