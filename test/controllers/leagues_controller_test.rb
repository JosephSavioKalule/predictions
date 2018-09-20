require 'test_helper'

class LeaguesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @league = leagues(:one)
    @lana = users(:lana)
  end
  
  test "should get index" do
    get leagues_path
    assert_response :success
  end
  
  test "should get show" do
    get league_path @league
    assert_response :success
  end
  
  test "should not get rankings if not logged in" do
    get "#{league_path(@league)}/rankings"
    assert_redirected_to login_path
  end
  
  test "should get rankings if logged in" do
    log_in_as @lana
    get "#{league_path(@league)}/rankings"
    assert_response :success
  end
end
