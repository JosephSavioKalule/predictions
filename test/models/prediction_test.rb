require 'test_helper'

class PredictionTest < ActiveSupport::TestCase
  def setup
    @user = users(:simon)
    @match = matches(:one)
    # This code is not idiomatically correct.
    #@prediction = Prediction.new(home_goals:1, away_goals:2, user_id: @user.id, match_id: @match.id)
    @prediction = @user.predictions.build(home_goals:1, away_goals:2, match_id: @match.id)
  end

  test "should be valid" do
    assert @prediction.valid?
  end

  test "user id should be present" do
    @prediction.user_id = nil
    assert_not @prediction.valid?
  end
  
  test "match id should be present" do
    @prediction.match_id = nil
    assert_not @prediction.valid?
  end
  
  test "score should not be negative" do
    @prediction.home_goals = -1
    assert_not @prediction.valid?
  end
end
