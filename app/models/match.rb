class Match < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, :class_name => 'Team'
  belongs_to :away_team, :class_name => 'Team'
  
  validates :league_id, presence: true
  validates :home_team, presence: true
  validates :away_team, presence: true
end
