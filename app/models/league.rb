class League < ApplicationRecord
  belongs_to :country
  belongs_to :season
  has_many :teams
  has_many :matches
  has_many :predictors

  validates :name, presence: true

  def past_matches
    @matches = self.matches.where("match_date_time < ?", 2.hours.ago)
                    .limit(4).order(match_date_time: :desc)
  end

  def future_matches
    @matches = self.matches.where("match_date_time > ?", Time.now + 30.seconds)
                    .limit(4).order(match_date_time: :desc)
  end

  def ongoing_matches
    @matches = self.matches.where("match_date_time < ? and match_date_time > ?",
               Time.now + 30.seconds, 2.hours.ago)
                    .limit(5).order(match_date_time: :desc)
  end
end
