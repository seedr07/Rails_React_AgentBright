require "test_helper"

class NylasApi::AccountTest < ActiveSupport::TestCase

  fixtures :users

  def setup
    @user = users(:jane)
    @token = @user.nylas_token
    stub_request(:any, /api.nylas.com/).to_rack(FakeNylas)
  end

  def test_initialization
    account = NylasApi::Account.new(@token)
    assert_not_nil(account)
  end

  def test_retrieve
    assert_not_nil(NylasApi::Account.new(@token).retrieve)
  end

  def test_retrieve_with_nil_token
    account = NylasApi::Account.new(nil).retrieve
    assert_nil(account)
  end

  def test_account_id
    account_id = NylasApi::Account.new(@token).account_id
    assert_equal "3sdlmdy4bnyy7rynd7ysuo8jy", account_id
  end

  def test_account_id_with_nil_token
    account_id = NylasApi::Account.new(nil).account_id
    assert_nil(account_id)
  end

  def test_account_id_with_bad_token
    account_id = NylasApi::Account.new("bad_token").account_id
    assert_nil(account_id)
  end

  def test_name
    name = NylasApi::Account.new(@token).name
    assert_equal "jane jones", name
  end

  def test_email_address
    email_address = NylasApi::Account.new(@token).email_address
    assert_equal "jane.jones.agentbright@gmail.com", email_address
  end

  def test_provider
    provider = NylasApi::Account.new(@token).provider
    assert_equal "gmail", provider
  end

  def test_organizational_unit
    organizational_unit = NylasApi::Account.new(@token).organizational_unit
    assert_equal nil, organizational_unit
  end

  def test_latest_cursor
    latest_cursor = NylasApi::Account.new(@token).latest_cursor
    assert_equal "625g26m3e6fvn42v4aedjzcc9", latest_cursor
  end

  def test_nylas_account_error
    NylasApi::Account.any_instance.stubs(:nylas_account).raises(Inbox::APIError.new("Error message", "Error message"))
    assert_nil NylasApi::Account.new(@token).retrieve
  end

end
