require 'test_helper'

class PredictionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:archer)
  end
  
  test "should redirect to login page" do
    get user_predictions_path(@user)
    assert_redirected_to login_path
  end
  
  test "should get index" do
    log_in_as @user
    get user_predictions_path(@user)
    assert_response :success
  end
  
end
