class Season < ApplicationRecord
  validates :start_year, presence: true
  validates_inclusion_of :start_year, in: 2018..2117
end