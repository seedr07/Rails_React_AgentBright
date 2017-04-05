require "test_helper"

class Api::V1::ContactsControllerTest < ActionController::TestCase

  def test_contacts
    user = users(:john)
    set_auth_headers!(user)

    get :index, params: { id: user.email, format: :json }
    assert_response :success
  end

  def test_contacts_when_email_is_not_present
    user = users(:john)
    an_invalid_email = "this_email_is_not_present_in_db@example.com"
    set_auth_headers!(user)

    get :index, params: { id: an_invalid_email, format: :json }
    assert_response 401
    assert_equal(
      "Could not authenticate with the provided credentials",
      JSON.parse(response.body)["error"]
    )
  end

  private

  def set_auth_headers!(user)
    request.headers["X-Auth-Token"] = user.authentication_token
  end

end
