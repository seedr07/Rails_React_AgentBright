require "test_helper"

class HomeControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    @nancy = users(:nancy)
    sign_in @nancy
  end

  def teardown
    sign_out @nancy
  end

  def test_set_show_narrow_main_nav_bar_success
    get :set_show_narrow_main_nav_bar
    assert_response :success
  end

  def test_index_success
    get :index
    assert_response :success
  end

  def test_get_first_four_leads_needing_action_success
    @controller = HomeController.new
    @controller.instance_eval { get_first_four_leads_needing_action }
  end

  def test_get_remaining_leads_needing_action_success
    @controller = HomeController.new
    @controller.instance_eval { get_remaining_leads_needing_action }
  end

  def test_sign_in_with_no_subscription
    @user = create(:user)
    sign_out(@nancy)
    sign_in(@user)
    get :index
    assert_redirected_to billing_url
  end

  def test_subscriber_sign_in
    @user = create(:subscriber)
    sign_out(@nancy)
    sign_in(@user)
    get :index
    assert_response :success
  end

end
