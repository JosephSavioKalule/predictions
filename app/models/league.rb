class League < ApplicationRecord
  belongs_to :country
  belongs_to :season
  has_many :teams
  has_many :matches
  
  validates :name, presence: true
end
