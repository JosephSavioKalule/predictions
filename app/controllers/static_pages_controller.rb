class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:settings]
  
  def home
    @leagues = League.all.order(:id)
    @upcoming_matches = Match.where("match_date_time < ? and match_date_time > ?",
                        3.days.from_now, 30.seconds.from_now).order(:match_date_time).limit(10)
    if logged_in?
      @user = current_user
    end
  end

  def help
  end
  
  def settings
    @user = current_user
    @settings = @user.settings_box
  end
end
