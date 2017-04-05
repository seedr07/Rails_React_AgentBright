require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase

  def setup
    @user = users(:john)
    @contact = Contact.create!(created_by_user_id: @user.id)
    PhoneNumber.destroy_all
  end

  def test_sanitize_phone_number
    phone_number = PhoneNumber.new(number: "(410 86-753 09)")
    phone_number.save

    assert_equal "4108675309", phone_number.number

    phone_number.number = nil
    assert_equal nil, phone_number.number

    phone_number = PhoneNumber.new
    assert_equal nil, phone_number.number
  end

  def test_owner_should_have_only_one_primary_phone_number
    @contact.phone_numbers.create(number: "4108675309",
                                 number_type: "mobile",
                                 primary: true)

    phone_number_2 = @contact.phone_numbers.create(number: "4508675308",
                                                  number_type: "home",
                                                  primary: true)

    assert_equal 1, @contact.phone_numbers.where(primary: true).count
    assert phone_number_2.primary?
  end

  def test_phone_is_getting_set_primary_if_contact_has_one_phone_number
    @contact.phone_numbers.build(number: "4108675309",
                                number_type: "mobile")

    @contact.save

    assert_equal 1, @contact.phone_numbers.count
    assert @contact.phone_numbers.first.primary?
  end

  def test_delete_phone_number_if_nubmer_is_blank?
    phone_address = @contact.phone_numbers.create(number: "4508675308",
                                                  number_type: "Work")

    @contact.attributes = { phone_numbers_attributes: [{ id: phone_address.id, number: "" }] }
    @contact.save

    assert_equal 0, @contact.phone_numbers.count
  end
end
