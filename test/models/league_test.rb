require 'test_helper'

class LeagueTest < ActiveSupport::TestCase
  setup do
    @league = leagues(:one)
  end
  
  test "League name must be present" do
    @league.name = nil
    assert_not @league.valid?
    @league.name = " "
    assert_not @league.valid?
  end
end
