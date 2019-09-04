require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @team = teams(:one)
    @simon = users(:simon)
    @archer = users(:archer)
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
  
  test "should not get edit if not admin" do
    log_in_as @archer
    get edit_team_path(@team)
    assert_redirected_to root_url
    #assert_not flash.empty?
  end
  
  test "should not get edit if not logged in" do
    get edit_team_path(@team)
    assert_redirected_to login_path
    assert_not flash.empty?
  end
  
  test "should get edit" do
    log_in_as @simon
    get edit_team_path(@team)
    assert_response :success
  end
  
  test "should not update team if not logged in" do
    patch team_path(@team),
         params: { team: { name: "Funny Name", logo_url: "wrong_url" }}
    @team.reload
    assert_not_equal @team.name, "Funny Name"
    assert_not_equal @team.logo_url, "wrong_url"
  end
  
  test "should not update team if not admin" do
    log_in_as @archer
    patch team_path(@team),
         params: { team: { name: "Funny Name", logo_url: "wrong_url" }}
    @team.reload
    assert_not_equal @team.name, "Funny Name"
    assert_not_equal @team.logo_url, "wrong_url"
  end
  
  test "should update team" do
    log_in_as @simon
    patch team_path(@team),
         params: { team: { name: "Funny Name", logo_url: "wrong_url" }}
    @team.reload
    assert_equal @team.name, "Funny Name"
    assert_equal @team.logo_url, "wrong_url"
  end
end