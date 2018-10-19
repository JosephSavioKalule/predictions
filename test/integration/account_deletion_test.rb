require 'test_helper'

class AccountDeletionTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:simon)
  end
  
  test "should delete account" do
    log_in_as @user
    get settings_path
    assert_response :success
    assert_select "input[type='password']"
    assert_difference 'User.count', -1 do
      post profile_delete_path, params: { user: { password: 'password' } }
    end
    assert_redirected_to root_path
    assert_not flash.empty?
  end
  
  test "should not delete account if password is wrong" do
    log_in_as @user
    get settings_path
    assert_response :success
    assert_select "input[type='password']"
    assert_no_difference 'User.count' do
      post profile_delete_path, params: { user: { password: 'wrong password' } }
    end
    assert_redirected_to profile_path
    assert_not flash.empty?
  end
  
  test "should not delete account if not logged in" do
    assert_no_difference 'User.count' do
      post profile_delete_path, params: { user: { password: 'password' } }
    end
    assert_redirected_to login_path
    assert_not flash.empty?
  end
end
