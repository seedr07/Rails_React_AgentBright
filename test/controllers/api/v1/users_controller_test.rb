require "test_helper"

class Api::V1::UsersControllerTest < ActionController::TestCase

  def test_show_for_a_valid_user
    admin = users(:admin)
    set_auth_headers!(admin)

    get :show, params: { id: admin.email, format: :json }

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal(user_attributes.sort, json.keys.sort)
  end

  def test_show_when_email_is_not_present
    admin = users :admin
    an_invalid_email = "this_email_is_not_present_in_db@example.com"
    set_auth_headers!(admin)

    get :show, params: { id: an_invalid_email, format: :json }

    assert_response 401
    assert_equal(
      "Could not authenticate with the provided credentials",
      JSON.parse(response.body)["error"]
    )
  end

  def test_create_user_with_valid_info
    valid_email = "ralph@example.com"

    valid_user_json = {
      email: valid_email,
      first_name: "Ralph",
      last_name: "Smith",
      password: "welcome1",
      password_confirmation: "welcome1",
      phone_number: "(555) 555-5555"
    }

    # Ensure that there are no users with this email in the db
    User.where(email: valid_email).delete_all

    assert_difference "User.count", 1 do
      post :create, params: { user: valid_user_json }
      assert_response :success
    end
  end

  def test_create_user_should_return_error_for_invalid_data
    valid_email = "ralph@example.com"

    invalid_user_json = {
      email: valid_email,
      first_name: "Ralph",
      last_name: "Smith",
      password: nil
    }

    User.where(email: valid_email).delete_all

    post :create, params: { user: invalid_user_json }
    assert_response 422
    assert_equal "Password Please enter a value", JSON.parse(response.body)["error"]
  end

  def test_update_should_not_succeed_without_authentication
    admin = users :admin
    json_data = admin.as_json
    put :update, params: { id: admin.email, user: json_data }
    assert_response 401
  end

  def test_update_should_return_error_when_email_is_not_present
    admin = users(:admin)
    an_invalid_email = "this_email_is_not_present_in_db@example.com"
    set_auth_headers!(admin)

    put :update, params: { id: an_invalid_email, format: :json }

    assert_response 401
    assert_equal(
      "Could not authenticate with the provided credentials",
      JSON.parse(response.body)["error"]
    )
  end

  def test_update_user_should_succeed_for_valid_data
    john = users(:john)
    new_first_name = "John2"
    set_auth_headers!(john)

    put(
      :update,
      params: {
        id: john.email,
        user: { first_name: new_first_name },
        format: :json
      }
    )

    assert_response :success
    john.reload
    assert_equal new_first_name, john.first_name
  end

  def test_update_user_should_return_error_for_invalid_data
    john = users(:john)

    set_auth_headers!(john)

    put(
      :update,
      params: {
        id: john.email,
        format: :json,
        user: {
          password: "new test password",
          password_confirmation: "not matching confirmation"
        }
      }
    )
    assert_response 422

    assert_equal(
      "Password confirmation doesn't match Password",
      JSON.parse(response.body)["error"],
      response.body
    )
  end

  def test_destroy_should_not_be_invokeable_without_authentication
    john = users(:john)
    delete :destroy, params: { id: john.email }
    assert_response 401

    assert_equal(
      "Could not authenticate with the provided credentials",
      JSON.parse(response.body)["error"]
    )
  end

  def test_destroy_should_destroy_user
    admin = users(:admin)
    set_auth_headers!(admin)

    assert_difference "User.count", -1 do
      delete :destroy, params: { id: admin.email, format: :json }
      assert_response :success
    end
  end

  def test_destroy_should_return_error_if_email_is_not_present_in_database
    admin = users :admin
    email = "this_email_is_not_present_in_db@example.com"

    set_auth_headers!(admin)

    delete :destroy, params: { id: email, format: :json }

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

  def user_attributes
    %w{
      ab_email_address
      account_marked_inactive_at
      address
      agent_percentage_split
      annual_broker_fees_paid
      authentication_token
      avatar_color
      billing_address
      billing_address_2
      billing_city
      billing_country
      billing_email_address
      billing_first_name
      billing_last_name
      billing_organization
      billing_state
      billing_zip_code
      broker_fee_alternative
      broker_fee_alternative_split
      broker_fee_per_transaction
      broker_percentage_split
      city
      commission_split_type
      company
      company_website
      contacts_count
      contacts_database_storage
      country
      created_at
      dly_calls_counter
      dly_notes_counter
      dly_visits_counter
      email
      email_campaign_track_clicks
      email_campaign_track_opens
      email_signature
      email_signature_status
      fax_number
      first_name
      franchise_fee
      franchise_fee_per_transaction
      id
      initial_setup
      last_cursor
      last_name
      lead_form_key
      mobile_number
      monthly_broker_fees_paid
      name
      nilas_account_status
      nilas_calendar_setting_id
      nilas_trial_status_set_at
      number_of_closed_leads_YTD
      nylas_account_id
      nylas_connected_email_account
      nylas_sync_status
      nylas_token
      office_number
      per_transaction_fee_capped
      personal_website
      profile_pic
      real_estate_experience
      show_beta_features
      show_narrow_main_nav_bar
      state
      stripe_customer_id
      subscribed
      subscription_account_status
      subscription_account_status_marked_inactive_at
      super_admin
      team_group_id
      team_id
      time_zone
      transaction_fee_cap
      twitter_secret
      twitter_token
      ungraded_contacts_count
      updated_at
      wkly_calls_counter
      wkly_notes_counter
      wkly_visits_counter
      zip
      team_name
    }
  end

end
