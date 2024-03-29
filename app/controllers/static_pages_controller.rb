class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:settings]

  def home
    @season = Season.last
    @leagues = @season.leagues.order(:id)
    d = DateTime.now
    @upcoming_matches = Match.where("match_date_time < ? and match_date_time > ?",
                        3.days.from_now, 30.seconds.from_now).order(:match_date_time).limit(10)
    @upcoming_today = Match.where("match_date_time <? and match_date_time > ?",
                                  (24-d.hour).hours.from_now, 30.seconds.from_now)
    @upcoming_tomor = Match.where("match_date_time <? and match_date_time > ?",
                                  (48-d.hour).hours.from_now, (24-d.hour).hours.from_now)
    @upcoming_later = Match.where("match_date_time > ?", (48-d.hour).hours.from_now)
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
