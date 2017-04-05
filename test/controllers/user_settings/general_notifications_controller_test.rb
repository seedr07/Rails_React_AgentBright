require "test_helper"

class UserSettings::GeneralNotificationsControllerTest < ActionController::TestCase

  fixtures :users, :lead_settings

  def setup
    @nancy = users(:nancy)
    sign_in @nancy
  end

  def test_general_notifications_index_success_response
    get :index
    assert_response :success
  end

end
