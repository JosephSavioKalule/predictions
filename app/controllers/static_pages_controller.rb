class StaticPagesController < ApplicationController
  def home
    @leagues = League.all.order(:id)
    if logged_in?
      @user = current_user
    end
  end

  def help
  end
end
