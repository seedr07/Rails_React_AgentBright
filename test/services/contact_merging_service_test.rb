require "test_helper"

class ContactMergingServiceTest < ActiveSupport::TestCase

  fixtures :users, :contacts, :leads, :email_addresses, :phone_numbers

  def setup
    @user = users(:john)
    @will_contact_in_database = contacts(:will)
  end

  def test_returns_existing_contact_if_present
    contact = ContactMergingService.new(
      @user,
      will_contact_newly_imported,
    ).perform
    assert_equal @will_contact_in_database, contact
  end

  def test_no_matching_contact_found
    new_contact = will_contact_newly_imported
    @will_contact_in_database.destroy
    contact = ContactMergingService.new(
      @user,
      new_contact,
    ).perform
    assert_equal false, contact.persisted?
  end

  def test_merge_new_email_addresses_if_contact_present
    contact = ContactMergingService.new(
      @user,
      will_contact_newly_imported,
    ).perform
    assert_equal @will_contact_in_database, contact
    assert_equal 2, contact.email_addresses.count, "Should only be 2 email addresses"
  end

  def test_merge_new_phone_numbers_if_contact_present
    contact = ContactMergingService.new(
      @user,
      will_contact_newly_imported,
    ).perform
    assert_equal @will_contact_in_database, contact
    assert_equal 2, contact.phone_numbers.count, "Should only be 2 phone numbers"
  end

  private

  def will_contact_newly_imported
    contact = @will_contact_in_database.dup
    contact.email_addresses.build(email: "will@example.com", primary: true)
    contact.email_addresses.build(email: "wills_other_email@example.com")
    contact.phone_numbers.build(number: "010-555-1141")
    contact.phone_numbers.build(number: "860-434-3424")
    contact
  end

end
