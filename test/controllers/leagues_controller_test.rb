require 'test_helper'

class LeaguesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @league = leagues(:one)
  end
  
  test "should get index" do
    get leagues_path
    assert_response :success
  end
  
  test "should get show" do
    get league_path @league
    assert_response :success
  end
end
