require "test_helper"

class ApplicationHelperTest < ActionView::TestCase

  def setup
    @user = users(:john)
    @contact = contacts(:jane)
    @lead = leads(:katie)
  end

  def test_get_initials_from_names
    assert_equal("JS", get_initials_from_names("John", "Smith"))
    assert_equal("J", get_initials_from_names("John", nil))
    assert_equal("S", get_initials_from_names(nil, "Smith"))
  end

  def test_boolean_to_words
    assert_equal("Yes", boolean_to_words(true))
    assert_equal("No", boolean_to_words(false))
    assert_equal("No", boolean_to_words(nil))
  end

  def test_num_to_currency
    assert_equal("$1,000", num_to_currency(1_000.43))
    assert_equal("-", num_to_currency(nil))
  end

  def test_num_to_currency_truncated
    assert_equal("-", num_to_currency_truncated(nil))
    assert_equal("$3m", num_to_currency_truncated(3_400_000))
    assert_equal("$3m", num_to_currency_truncated(3_900_000))
    assert_equal("$400k", num_to_currency_truncated(400_000))
    assert_equal("$0k", num_to_currency_truncated(200))
  end

  def test_commission_rate_to_s
    assert_equal("6.00", commission_rate_to_s(6))
    assert_equal("5.50", commission_rate_to_s(5.5))
    assert_equal("-", commission_rate_to_s(nil))
  end

  def test_decimal_to_percentage
    assert_equal("-", decimal_to_percentage(nil))
    assert_equal("50", decimal_to_percentage(0.5))
    assert_equal("50.0", decimal_to_percentage(0.5, precision: 1))
    assert_equal("50.00", decimal_to_percentage(0.5, precision: 2))
  end

  def test_decimal_rate_to_progress_bar
    assert_equal(0, decimal_rate_to_progress_bar(nil))
    assert_equal("100", decimal_rate_to_progress_bar(1))
    assert_equal("50", decimal_rate_to_progress_bar(0.5))
    assert_equal("50", decimal_rate_to_progress_bar(0.4999))
    assert_equal("100", decimal_rate_to_progress_bar(0.999))
  end

  def test_fraction_to_percentage
    assert_nil(fraction_to_percentage(nil, nil))
    assert_nil(fraction_to_percentage(nil, 100))
    assert_nil(fraction_to_percentage(100, nil))
    assert_equal("50", fraction_to_percentage(5, 10))
    assert_equal("33", fraction_to_percentage(3, 9))
    assert_equal("33.33", fraction_to_percentage(3, 9, precision: 2))
  end

  def test_progress_bar_sm
    progress_bar = progress_bar_sm("Clients", 4, 4, 20)
    assert_match(/Clients/, progress_bar)
    assert_match(/20\.0\%/, progress_bar)
    progress_bar = progress_bar_sm("Clients", 4, 0, 0)
    assert_match(/Clients/, progress_bar)
    assert_match(/aria\-valuenow\=\"0\"/, progress_bar)
  end

  def test_check_connection
    ActionView::TestCase.any_instance.stubs(:current_user).returns(users(:jane))
    assert_nil(check_connection("Google"))
    ActionView::TestCase.any_instance.stubs(:current_user).returns(@user)
    assert_match(/\>Disconnect\</, check_connection("Google"))
    auth = authorizations(:john_auth)
    assert_match(authorization_path(auth), check_connection("Google"))
  end

  def test_connection_status
    ActionView::TestCase.any_instance.stubs(:current_user).returns(users(:jane))
    assert_match(/fui\-cross/, connection_status("Google"))
    ActionView::TestCase.any_instance.stubs(:current_user).returns(@user)
    assert_match(/fui\-check/, connection_status("Google"))
  end

  def test_underscored
    assert(underscored?("_John"))
    assert_nil(underscored?("John"))
    assert_nil(underscored?(nil))
  end

  def test_slat_data_block
    assert_match(/data inline\-block/, slat_data_block)
    assert_match(/Clients/, slat_data_block("Clients", 13))
    assert_match(/13/, slat_data_block("Clients", 13))
  end

  def test_no_data_block
    block = no_data_block(
      icon_class: "mdi-action-done",
      title: "Buyer Properties",
      message: "No Current Properties."
    )
    assert_match(/mdi\-action\-done/, block)
    assert_match(/\<h2\>/, block)
    block = no_data_block(icon_class: "mdi-action-done") { "Block body" }
    assert_no_match(/\<h2\>/, block)
    assert_match(/Block body/, block)
  end

end
