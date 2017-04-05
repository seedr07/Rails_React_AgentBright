require "test_helper"
require "datetime_formatting_helper"
require "leads_helper"

class ContactsHelperTest < ActionView::TestCase

  include DatetimeFormattingHelper
  include LeadsHelper

  fixtures :contacts, :leads, :images, :users

  def setup
    @contact = Contact.create(
      created_by_user_id: 1,
      first_name: "John",
      grade: "A"
    )
    @will = contacts(:will)
    @lead = leads(:katie)
    @user = users(:john)
    VCR.insert_cassette("contacts_helper_test")
  end

  def teardown
    VCR.eject_cassette
  end

  def test_contact_display_name_with_full_name
    assert_equal "John", contact_display_name(@contact)
  end

  def test_contact_display_name_with_no_name
    @contact.update(first_name: nil, last_name: nil)
    @contact.email_addresses.create(
      email: "john@example.com",
      email_type: "Personal",
      primary: true
    )
    assert_equal "john@example.com", contact_display_name(@contact)
  end

  def test_contact_display_name_with_no_name_or_email
    @contact.update(first_name: nil, last_name: nil)
    assert_equal "Unknown", contact_display_name(@contact)
  end

  def test_next_contact_date_to_s
    travel_to Time.new(2016, 03, 31, 12, 00, 00)
    assert_equal "ASAP", next_contact_date_to_s(Time.current)
    assert_equal "N/A", next_contact_date_to_s(nil)
    assert_equal "Apr  1, 2016", next_contact_date_to_s(Time.current + 1.day)
  end

  def test_contact_activity_status_color
    assert_equal "neutral", contact_activity_status_color(@contact)
    @contact.update_columns(last_note_sent_at: Time.current - 180.days)
    assert_equal "danger", contact_activity_status_color(@contact)
    @contact.reload.update_columns(last_note_sent_at: Time.current - 20.days)
    assert_equal "warning", contact_activity_status_color(@contact)
    @contact.reload.update_columns(last_note_sent_at: Time.current - 5.days)
    assert_equal "success", contact_activity_status_color(@contact)
  end

  def test_contact_avatar
    @contact.update_columns(avatar_color: 6)
    assert_equal "<span class='initials-100 rounded abg6'>
        J
      </span>", contact_avatar(@contact)
  end

  def test_contact_display_name
    assert_equal "John", contact_display_name(@contact)
  end

  def test_time_since_last_contacted
    assert_equal "Not yet contacted", time_since_last_contacted(@contact)
  end

  def test_display_contact_slats_data
    # ask patrick
    assert_equal "", display_contact_slats_data(@contact)
    assert_equal 3, @will.contact_activities.count
    assert_equal "<div class=\"data inline-block float-left\">
        <h4>Not yet contacted</h4>
        <p class=\"dim-el\">Last contacted</p>
      </div><!-- /data -->", display_contact_slats_data(@will)
  end

  def test_display_primary_phone_number
    assert_equal "", display_primary_phone_number(@contact)
    @contact.phone_numbers.create(
      number: "2144542222",
      number_type: "Mobile",
      primary: true
    )
    assert_equal "(214) 454-2222", display_primary_phone_number(@contact)
  end

  def test_display_primary_email_address
    assert_equal nil, display_primary_email_address(@contact)
    @contact.email_addresses.create(
      email: "john@example.com",
      email_type: "Personal",
      primary: true
    )
    assert_equal "john@example.com", display_primary_email_address(@contact)
  end

  def test_formatted_lead_name
    assert_equal "Katie Lozar", formatted_lead_name(@lead)
    Contact.any_instance.stubs(:full_name).returns(nil)
    assert_equal "katie", formatted_lead_name(@lead)
    Contact.any_instance.stubs(:primary_email_address).returns(nil)
    assert_equal "(01) 055-5111", formatted_lead_name(@lead)
    Lead.any_instance.stubs(:lead_source_to_s).returns("Trulia")
    assert_equal "Trulia (01) 055-5111", formatted_lead_name(@lead)
  end

  def test_format_phone_number_method
    phone_number = @contact.phone_numbers.create(
      number: "2144542222",
      number_type: "Mobile",
      primary: true
    )
    phone_number2 = @contact.phone_numbers.create(
      number: "2144541111",
      number_type: "Work",
      primary: false
    )
    assert_equal(
      "(214) 454-2222 (Mobile) - <b>Primary</b>",
      format_phone_number(phone_number)
    )
    assert_equal(
      "(214) 454-1111 (Work)",
      format_phone_number(phone_number2)
    )
  end

  def test_format_email_address
    email_address = @contact.email_addresses.create(
      email: "john@example.com",
      email_type: "Personal",
      primary: true
    )
    email_address2 = @contact.email_addresses.create(
      email: "john+work@example.com",
      email_type: "Work",
      primary: false
    )
    assert_equal(
      "john@example.com (Personal) - <b>Primary</b>",
      format_email_address(email_address)
    )
    assert_equal(
      "john+work@example.com (Work)",
      format_email_address(email_address2)
    )
  end

  def test_grade_popover_circle
    # ask patrick - error
    assert_equal "<span class='initials-68 circle grade'>test label</span>", grade_popover_circle("test label")
  end

  def test_grade_tooltip
    assert_equal "B2B relations/multi-referrals", grade_tooltip(@contact.grade)
    @contact.reload.update_columns(grade: 5)
    assert_equal "Ranking Contacts helps keep in touch", grade_tooltip(@contact.grade)
    @contact.reload.update_columns(grade: 4)
    assert_equal "Exclude from Marketing - other agents/out of towners", grade_tooltip(@contact.grade)
    @contact.reload.update_columns(grade: 3)
    assert_equal "Folks that may not know you're an Agent", grade_tooltip(@contact.grade)
    @contact.reload.update_columns(grade: 2)
    assert_equal "Folks you may have lost touch with", grade_tooltip(@contact.grade)
    @contact.reload.update_columns(grade: 1)
    assert_equal "Clients, Family & Friends that refer", grade_tooltip(@contact.grade)
  end

  def test_active_contacts_sorted_by_first_name
    assert_equal "Adam Smith", active_contacts_sorted_by_first_name(@user).first.name
    assert_equal "Will O'Smith", active_contacts_sorted_by_first_name(@user).last.name
  end

end
