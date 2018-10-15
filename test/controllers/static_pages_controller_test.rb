require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:simon)
  end
  
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Predictions"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | Predictions"
  end
  
  test "should get settings" do
    log_in_as @user
    get settings_path
    assert_response :success
    assert_select "title", "Settings | Predictions"
  end
  
  test "should not get settings if not logged in" do
    get settings_path
    assert_redirected_to login_path
    assert_not flash.empty?
  end

end
