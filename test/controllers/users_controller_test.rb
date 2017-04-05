require "test_helper"

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = create(:user)
    @super_admin = create(:super_admin)
  end

  def test_billing_page
    sign_in @user
    get :billing
    assert_response :success
  end

  def test_billing_page_without_sign_in
    get :billing
    assert_redirected_to new_user_session_url
  end

  def test_index
    sign_in @super_admin
    get :index
    assert_response :success
  end

  def test_show
    sign_in @super_admin
    get :show, params: { id: @user.id }
    assert_response :success
  end

end
