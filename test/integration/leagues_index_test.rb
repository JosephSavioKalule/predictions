require 'test_helper'

class LeaguesIndexTest < ActionDispatch::IntegrationTest
  def setup
  end
  
  test "should show index" do
    get leagues_path
    assert_response :success
    assert_select "h1", "Leagues"
  end
end
