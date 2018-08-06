class Prediction < ApplicationRecord
  belongs_to :user
  belongs_to :match
  
  validates :user_id, presence: true
  validates :match_id, presence: true
  validates :home_goals, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :away_goals, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
