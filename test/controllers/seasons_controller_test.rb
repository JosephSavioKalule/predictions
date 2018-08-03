require 'test_helper'

class SeasonsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @season = seasons(:one)
  end
  
  test "should get index" do
    get seasons_path
    assert_response :success
  end

  test "should get show" do
    get season_path @season
    assert_response :success
  end

end
