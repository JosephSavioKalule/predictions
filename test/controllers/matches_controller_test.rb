require 'test_helper'

class MatchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:simon)
    @other_user = users(:archer)
    @league = leagues(:two)
    @arsenal = teams(:one)
    @watford = teams(:two)
    @match = matches(:two)
  end
  
  test "admin should be able to create new match" do
    log_in_as @admin_user
    get new_league_match_path(@league)
    assert_response :success
    assert_difference 'Match.count', 1 do
      post league_matches_path(@league),
           params: { match: { home_team_id: @arsenal.id, away_team_id: @watford.id, match_date_time: Time.now + 2.days }}
    end
  end
  
  test "other user should not be able to create new match" do
    log_in_as @other_user
    get new_league_match_path(@league)
    assert_redirected_to root_path
    assert_no_difference 'Match.count' do
      post league_matches_path(@league),
           params: { match: { home_team_id: @arsenal.id, away_team_id: @watford.id, match_date_time: Time.now + 2.days }}
    end
  end
  
  test "admin should be able to edit match" do
    log_in_as @admin_user
    get edit_league_match_path(@match.league, @match)
    assert_response :success
    patch league_match_path(@match.league, @match),
         params: { match: { match_date_time: Time.now + 3.days }}
    assert_not_equal @match.match_date_time, @match.reload.match_date_time
  end
  
  test "other user should not be able to edit match" do
    log_in_as @other_user
    get new_league_match_path(@match.league, @match)
    assert_redirected_to root_path
    patch league_match_path(@match.league, @match),
         params: { match: { match_date_time: Time.now + 3.days }}
    assert_equal @match.match_date_time, @match.reload.match_date_time
  end
  
  test "admin should see new match links on matches page" do
    log_in_as @admin_user
    get league_matches_path(@league)
    assert_response :success
    assert_select "a[href=?]", new_league_match_path(@league), count: 2
  end
  
  test "other user should not see new link on matches page" do
    log_in_as @other_user
    get league_matches_path(@league)
    assert_response :success
    assert_select "a[href=?]", new_league_match_path(@league), count: 0
  end
  
  test "admin should see edit link on match page" do
    log_in_as @admin_user
    get league_match_path(@match.league, @match)
    assert_response :success
    assert_select "a[href=?]", edit_league_match_path(@match.league, @match), count: 1
  end
  
  test "other user should not see edit link on match page" do
    log_in_as @other_user
    get league_match_path(@match.league, @match)
    assert_response :success
    assert_select "a[href=?]", edit_league_match_path(@match.league, @match), count: 0
  end

  test "admin should be able to delete match" do
    log_in_as @admin_user
    @league = @match.league
    assert_difference 'Match.count', -1 do
      delete league_match_path(@league, @match)
    end
    assert_redirected_to league_matches_path(@league)
  end

  test "other user should not be able to delete match" do
    log_in_as @other_user
    assert_no_difference 'Match.count' do
      delete league_match_path(@match.league, @match)
    end
  end
end
