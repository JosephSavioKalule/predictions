require 'test_helper'

class PredictionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @archer = users(:archer)
    @archers_prediction_imminent = predictions(:four)
    @archers_prediction_future = predictions(:five)
    @finished_match = matches(:one)
    @future_match = matches(:two)
    @imminent_match = matches(:three)
  end
  
  test "should redirect to login page" do
    get user_predictions_path(@archer)
    assert_redirected_to login_path
  end
  
  test "should get index" do
    log_in_as @archer
    get user_predictions_path(@archer)
    assert_response :success
  end
  
  test "should get prediction" do
    log_in_as @archer
    get user_prediction_path(@archer, @archers_prediction_imminent)
    assert_response :success
  end
  
end
