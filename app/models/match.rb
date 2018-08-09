class Match < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, :class_name => 'Team'
  belongs_to :away_team, :class_name => 'Team'
  
  has_many :predictions
  
  validate do |match|
    Validator.new(match).validate
  end
  
  validates :league_id, presence: true
  validates :home_team_id, presence: true
  validates :away_team_id, presence: true
  validates :match_date_time, presence: true
  
  validates :home_goals, inclusion: { in: 0..16,
    message: "Goals can't be negative" }, if: :home_goals?
  validates :away_goals, inclusion: { in: 0..16,
    message: "Goals can't be negative" }, if: :away_goals?
end

class Validator
  def initialize(match)
    @match = match
  end
 
  def validate
    if @match.home_team_id == @match.away_team_id
      @match.errors[:base] << "Away team must be different from Home team"
    end
  end
end