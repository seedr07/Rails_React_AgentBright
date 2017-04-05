require "test_helper"

class Contact::SalutationServiceTest < ActiveSupport::TestCase

  def setup
    @contact = Contact.new
  end

  test "should return full name when spouse names are nil" do
    @contact.assign_attributes(
      first_name: "Mike",
      last_name: "D'Fantis",
      spouse_first_name: nil,
      spouse_last_name: nil
    )
    assert_equal(
      "Mike D'Fantis,",
      Contact::SalutationService.new(@contact).envelope
    )
  end

  test "should return combined names when spouse has first name" do
    @contact.assign_attributes(
      first_name: "Mike",
      last_name: "D'Fantis",
      spouse_first_name: "Katie",
      spouse_last_name: nil
    )
    assert_equal(
      "Mike & Katie D'Fantis,",
      Contact::SalutationService.new(@contact).envelope
    )
  end

  test "should return combined names when spouse has same last name" do
    @contact.assign_attributes(
      first_name: "Mike",
      last_name: "D'Fantis",
      spouse_first_name: "Katie",
      spouse_last_name: "D'Fantis"
    )
    assert_equal(
      "Mike & Katie D'Fantis,",
      Contact::SalutationService.new(@contact).envelope
    )
  end

  test "should return both full names when spouse has different last name" do
    @contact.assign_attributes(
      first_name: "Mike",
      last_name: "D'Fantis",
      spouse_first_name: "Katie",
      spouse_last_name: "Alexander"
    )
    assert_equal(
      "Mike D'Fantis & Katie Alexander,",
      Contact::SalutationService.new(@contact).envelope
    )
  end

  test "should return blank if missing first name" do
    @contact.assign_attributes(
      first_name: nil,
      last_name: "D'Fantis",
      spouse_first_name: "Katie",
      spouse_last_name: "D'Fantis"
    )
    assert_equal(
      "",
      Contact::SalutationService.new(@contact).envelope
    )
  end

  test "should return blank if missing last name" do
    @contact.assign_attributes(
      first_name: "Mike",
      last_name: nil,
      spouse_first_name: "Katie",
      spouse_last_name: "D'Fantis"
    )
    assert_equal(
      "",
      Contact::SalutationService.new(@contact).envelope
    )
  end

  test "should return both names if contact and spouse's first names present" do
    @contact.assign_attributes(
      first_name: "Mike",
      spouse_first_name: "Katie"
    )
    assert_equal(
      "Dear Mike & Katie,",
      Contact::SalutationService.new(@contact).letter
    )
  end

  test "should return contact's first name if spouse's first name missing" do
    @contact.assign_attributes(
      first_name: "Mike",
      spouse_first_name: nil
    )
    assert_equal(
      "Dear Mike,",
      Contact::SalutationService.new(@contact).letter
    )
  end

  test "should blank contact's first name missing" do
    @contact.assign_attributes(
      first_name: nil
    )
    assert_equal(
      "",
      Contact::SalutationService.new(@contact).letter
    )
  end

end
