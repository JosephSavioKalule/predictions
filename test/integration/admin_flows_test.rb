require 'test_helper'

class AdminFlowsTest < ActionDispatch::IntegrationTest
  def setup
    @team = teams(:one)
    @league = leagues(:one)
    @simon = users(:simon)      # admin
    @archer = users(:archer)    # not admin
    @future_match = matches(:two)
  end
  
  test "ordinary user login followed by attempts at unauthorized actions" do
    log_in_as @archer
    get league_path @league
    assert_response :success
    assert_select "a[href=?]", edit_league_path(@league), count: 0
    get edit_league_path(@league)
    assert_redirected_to root_url
    get team_path @team
    assert_response :success
    assert_select "a[href=?]", edit_team_path(@team), count: 0
    get edit_team_path(@team)
    assert_redirected_to root_url
    get league_match_path(@future_match.league, @future_match)
    assert_response :success
    assert_select "a[href=?]", edit_league_match_path(@future_match.league, @future_match), count: 0
    get edit_league_match_path(@future_match.league, @future_match)
    assert_redirected_to root_url
  end
  
  test "admin user login followed by attempts at elevated rights actions" do
    log_in_as @simon
    get league_path @league
    assert_response :success
    assert_select "a[href=?]", edit_league_path(@league), count: 1
    get edit_league_path(@league)
    assert_response :success
    get team_path @team
    assert_response :success
    assert_select "a[href=?]", edit_team_path(@team), count: 1
    get edit_team_path(@team)
    assert_response :success
    get league_match_path(@future_match.league, @future_match)
    assert_response :success
    assert_select "a[href=?]", edit_league_match_path(@future_match.league, @future_match), count: 1
    get edit_league_match_path(@future_match.league, @future_match)
    assert_response :success
  end
end
