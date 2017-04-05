require 'test_helper'

class EmailAddressesTest < ActiveSupport::TestCase

  def setup
    @user = users(:john)
    @contact = Contact.create!(created_by_user_id: @user.id)

    EmailAddress.destroy_all
  end

  def test_owner_should_have_only_one_primary_email
    @contact.email_addresses.create(email: "john@example.com",
                                   email_type: "Work",
                                   primary: true)

    email_address_2 = @contact.email_addresses.create(email: "alice@example.com",
                                                     email_type: "Work",
                                                     primary: true)

    assert_equal 1, @contact.email_addresses.where(primary: true).count
    assert email_address_2.primary?
  end

  def test_email_is_getting_set_as_primary_if_contact_has_one_email_address
    @contact.email_addresses.create(email: "john-adams@example.com",
                                    email_type: "Work")

    assert_equal 1, @contact.email_addresses.count
    assert @contact.email_addresses.first.primary?
  end

  def test_delete_email_address_if_email_is_blank?
    email_address = @contact.email_addresses.create(email: "john-peter@example.com",
                                                    email_type: "Work")

    @contact.attributes = { email_addresses_attributes: [{ id: email_address.id, email: "" }] }
    @contact.save

    assert_equal 0, @contact.email_addresses.count
  end
end
