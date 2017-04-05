require "test_helper"

class NylasApi::AccountTest < ActiveSupport::TestCase

  fixtures :users

  def setup
    @user = users(:jane)
    @token = @user.nylas_token
    stub_request(:any, /api.nylas.com/).to_rack(FakeNylas)
  end

  def teardown
  end

  def test_initialize
    admin = NylasApi::Admin.new
    assert_not_nil(admin)
  end

  def test_upgrade
    skip
    NylasApi::Admin.new("abcdefghijklmnop").upgrade
  end

  def test_downgrade
    skip
    NylasApi::Admin.new("abcdefghijklmnop").downgrade
  end

end
