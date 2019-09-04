require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  setup do
    @team = teams(:one)
  end
  
  test "Team name must be present" do
    @team.name = nil
    assert_not @team.valid?
    @team.name = " "
    assert_not @team.valid?
  end
end
