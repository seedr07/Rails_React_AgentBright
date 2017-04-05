require "test_helper"

class ApisControllerTest < ActionController::TestCase

  fixtures :users, :contacts

  def setup
    @will = contacts(:will)
    @jane = contacts(:jane)
    @nancy = users(:nancy)
    sign_in @nancy
  end

  def test_report_dashboard_success
    get :report_dashboard
    assert_response :success
  end

  def test_single_report_dashboard_success
    get :single_report_dashboard, params: { api: "twilio" }
    assert_response :success
  end

end
