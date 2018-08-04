class StaticPagesController < ApplicationController
  def home
    @leagues = League.all.order(:id)
  end

  def help
  end
end
