class League < ApplicationRecord
  belongs_to :country
  belongs_to :season
  has_many :teams
  has_many :matches
  has_many :predictors
  
  validates :name, presence: true
end
