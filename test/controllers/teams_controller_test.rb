require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @team = teams(:one)
  end
  
  test "should get index" do
    get teams_path
    assert_response :success
  end
  
  test "should get show" do
    get team_path @team
    assert_response :success
    assert_select "a[href=?]", league_path(@team.league)
  end
end