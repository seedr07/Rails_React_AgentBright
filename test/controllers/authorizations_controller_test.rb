require "test_helper"

class AuthorizationsControllerTest < ActionController::TestCase

  fixtures :announcements, :users

  def setup
    @announcement = announcements(:one)
    @john = users(:john)
    sign_in @john
  end

  def test_update_nilas_calendar_setting_redirect
    post :update_nilas_calendar_setting, params: { "calendar" => { "id" => "x78ahn8ad3d" } }
    assert_response :redirect
  end

  def test_update_nilas_calendar_setting_redirect_fail
    User.any_instance.expects(:save).returns(false)
    post :update_nilas_calendar_setting, params: { "calendar" => { "id" => "x78ahn8ad3d" } }
    assert_redirected_to edit_integrations_url
    assert_equal(
      "Sorry there was an error updating your calendar setting, please try again.",
      flash[:danger]
    )
  end

  def test_add_inbox_email_address
    users(:jane).update_columns(
      nylas_token: nil,
      nylas_connected_email_account: nil
    )
    get :add_inbox_email_address, params: { email: "jane.jones.agentbright@gmail.com" }
    assert_response :redirect
  end

  def test_inbox_login_callback_user
    Nylas::API.any_instance.stubs(:token_for_code).returns("fake_token")
    User.any_instance.stubs(:save!).returns(true)
    get :inbox_login_callback
    assert_redirected_to edit_integrations_path
  end

  def test_inbox_login_callback_user_api_error
    Nylas::API.any_instance.stubs(:token_for_code).raises(Nylas::APIError.new("error", "error"))
    assert_difference("ApiResponse.count", 1) do
      get :inbox_login_callback, params: { code: "testing123" }
    end
    assert_redirected_to edit_integrations_path
  end

  def test_inbox_login_callback_user_socket_error
    Nylas::API.any_instance.stubs(:token_for_code).raises(SocketError.new("error"))
    assert_difference("ApiResponse.count", 1) do
      get :inbox_login_callback, params: { code: "testing123" }
    end
    assert_redirected_to edit_integrations_path
  end

  def test_delete_nylas_token
    NylasApi::Admin.any_instance.stubs(:downgrade).returns(true)
    get :delete_nylas_token
    assert_redirected_to edit_integrations_path
  end

  def test_delete_nylas_token_fail
    NylasApi::Admin.any_instance.stubs(:downgrade).returns(false)
    get :delete_nylas_token
    assert_redirected_to edit_integrations_path
    assert_equal(
      "Sorry there was an error terminating your account. Please try again.",
      flash[:danger]
    )
  end

  def test_inbox_login_callback_user_has_token
    User.any_instance.stubs(:nylas_token).returns(true)
    get :inbox_login_callback
    assert_redirected_to edit_integrations_path
  end

  def test_authorization_delete_success
    assert_difference("Authorization.count", -1) do
      delete :destroy, params: { id: authorizations(:one).id }
    end
  end

end
