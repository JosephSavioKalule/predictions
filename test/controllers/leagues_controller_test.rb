require 'test_helper'

class LeaguesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @league = leagues(:one)
    @simon = users(:simon)
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
  
  test "should not get edit if not admin" do
    log_in_as @lana
    get edit_league_path(@league)
    assert_redirected_to root_url
  end
  
  test "should not get edit if not logged in" do
    get edit_league_path(@league)
    assert_redirected_to login_path
    assert_not flash.empty?
  end
  
  test "should get edit" do
    log_in_as @simon
    get edit_league_path(@league)
    assert_response :success
  end
  
  test "should not update league if not logged in" do
    patch league_path(@league),
         params: { league: { name: "Funny Name", logo_url: "wrong_url" }}
    @league.reload
    assert_not_equal @league.name, "Funny Name"
    assert_not_equal @league.logo_url, "wrong_url"
  end
  
  test "should not update league if not admin" do
    log_in_as @lana
    patch league_path(@league),
         params: { league: { name: "Funny Name", logo_url: "wrong_url" }}
    @league.reload
    assert_not_equal @league.name, "Funny Name"
    assert_not_equal @league.logo_url, "wrong_url"
  end
  
  test "should update league" do
    log_in_as @simon
    patch league_path(@league),
         params: { league: { name: "Funny Name", logo_url: "wrong_url" }}
    @league.reload
    assert_equal @league.name, "Funny Name"
    assert_equal @league.logo_url, "wrong_url"
  end
end
