require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def test_basic_validations
    address = Address.new

    address.require_basic_address_validations = true
    address.save

    error_message = "Enter at least address, city, state or zip code"
    assert_includes address.errors[:base], error_message
  end
end
