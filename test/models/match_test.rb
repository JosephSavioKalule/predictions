require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  def setup
    @match = matches(:two)
  end
  
  test "home team should be different from away team" do
    assert @match.valid?
    @match.home_team_id = @match.away_team_id
    assert_not  @match.valid?
  end
  
  test "match date and time must be present" do
    @match.match_date_time = nil
    assert_not @match.valid?
  end
  
  test "home goals cannot be negative" do
    @match.home_goals = -1
    assert_not @match.valid?
  end
  
  test "away goals cannot be negative" do
    @match.home_goals = 0
    @match.away_goals = -1
    assert_not @match.valid?
  end
end
