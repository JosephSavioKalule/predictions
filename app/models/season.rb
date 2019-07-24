class Season < ApplicationRecord
  has_many :teams
  has_many :leagues
  
  validates :start_year, presence: true
  validates_inclusion_of :start_year, in: 2018..2117
end
