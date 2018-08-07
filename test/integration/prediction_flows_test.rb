require 'test_helper'

class PredictionFlowsTest < ActionDispatch::IntegrationTest
  def setup
    @simon = users(:simon)
    @lana = users(:lana)
    @archer = users(:archer)
    @future_match = matches(:two)
    @near_future_match = matches(:three)
    @past_match = matches(:one)
    @simons_prediction = predictions(:one)
    @lanas_prediction = predictions(:two)
  end
  
  test "should create prediction" do
    log_in_as @archer
    get league_match_path(@future_match.league, @future_match)
    assert_response :success
    assert_difference 'Prediction.count', 1 do
      post league_match_predictions_path(@future_match.league, @future_match), params: {
        prediction: {
          league_id: @future_match.league_id,
          match_id: @future_match.id,
          user_id: @archer.id,
          home_goals: 0,
          away_goals: 0
        }
      }
    end
  end
  
  test "should modify prediction" do
    log_in_as @simon
    patch user_prediction_path(@simon, @simons_prediction), params: {
      prediction: {
        home_goals: 2,
        away_goals: 4
      }
    }
    assert_not flash.empty?
    assert_equal @simons_prediction.reload.home_goals, 2
    assert_equal @simons_prediction.reload.away_goals, 4
  end
  
  test "should destroy prediction" do
    log_in_as @simon
    get league_match_path(@future_match.league, @future_match)
    assert_response :success
    assert_difference 'Prediction.count', -1 do
      delete user_prediction_path(@simon, @simons_prediction)
    end
    assert_not flash.empty?
  end
  
  test "should not destroy other users' predictions" do
    log_in_as @simon
    get league_match_path(@future_match.league, @future_match)
    assert_response :success
    assert_no_difference 'Prediction.count' do
      delete user_prediction_path(@lana, @lanas_prediction)
    end
  end
  
  test "should not modify other users' predictions" do
    log_in_as @simon
    get league_match_path(@future_match.league, @future_match)
    assert_response :success
    patch user_prediction_path(@lana, @lanas_prediction),
          params: {
            prediction: {
              league_id: @future_match.league_id,
              match_id: @future_match.id,
              user_id: @lana.id,
              home_goals: 10,
              away_goals: 10
            }
          }
    assert_equal @lanas_prediction, @lanas_prediction.reload
  end
  
  test "should not show prediction link on match page if not logged in" do
    get league_match_path(@future_match.league, @future_match)
    assert_response :success
    assert_select "a[href=?]",
      new_league_match_prediction_path(@future_match.league, @future_match), count: 0
  end
  
  test "should not show new prediction link on match page if match is past" do
    log_in_as @simon
    get league_match_path(@past_match.league, @past_match)
    assert_response :success
    assert_select "a[href=?]",
      new_league_match_prediction_path(@past_match.league, @past_match), count: 0
  end
  
  test "should not show new prediction link on match page if match is in less than 1 hour" do
    log_in_as @simon
    get league_match_path(@near_future_match.league, @near_future_match)
    assert_response :success
    assert_select "a[href=?]",
      new_league_match_prediction_path(@near_future_match.league, @near_future_match), count: 0
  end
  
  test "should not show edit prediction link on match page if match is past" do
    log_in_as @simon
    get league_match_path(@past_match.league, @past_match)
    assert_response :success
    assert_select "a[href=?]",
      edit_league_match_prediction_path(@past_match.league, @past_match), count: 0
  end
  
  test "should not create new prediction if match is in less than 1 hour" do
    log_in_as @simon
    assert_no_difference 'Prediction.count' do
      post league_match_predictions_path(@near_future_match.league, @near_future_match), params: {
        prediction: {
          league_id: @near_future_match.league_id,
          match_id: @near_future_match.id,
          user_id: @simon.id,
          home_goals: 2,
          away_goals: 2
        }
      }
    end
    assert_not flash.empty?
  end
end
