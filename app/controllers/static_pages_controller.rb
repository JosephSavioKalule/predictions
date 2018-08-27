class StaticPagesController < ApplicationController
  def home
    @leagues = League.all.order(:id)
    @upcoming_matches = Match.where("match_date_time < ? and match_date_time > ?", 3.days.from_now, 30.seconds.from_now)
    if logged_in?
      @user = current_user
    end
  end

  def help
  end
end
