require "test_helper"

class ContactTest < ActiveSupport::TestCase

  fixtures :contacts, :images, :contact_activities, :users, :addresses, :email_addresses

  def setup
    @contact = Contact.create(created_by_user_id: 1, first_name: "John")
    @will = contacts(:will)
    VCR.insert_cassette("contact_test")
  end

  def teardown
    VCR.eject_cassette
  end

  def test_refresh_contact_api_info
    assert @contact.refresh_contact_api_info
  end

  def test_basic_validations
    contact = Contact.new
    contact.phone_numbers.build
    contact.email_addresses.build

    contact.require_basic_validations = true
    contact.save

    error_message = "Enter at least first name, last name, email or phone number"
    assert_includes contact.errors[:base], error_message
  end

  def test_base_validations
    contact = Contact.new
    contact.phone_numbers.build
    contact.email_addresses.build

    contact.require_base_validations = true
    contact.save

    assert_includes contact.errors[:first_name], "Please enter a first name"
    assert_includes contact.errors[:last_name], "...or a last name"
  end

  def test_recent_activites
    contact = Contact.create!(created_by_user_id: 1, first_name: "John")

    contact.update(addresses_attributes: addresses_attributes)
    activities = contact.recent_activities.order("id desc")
    street = activities.map(&:parameters).first[:changes]["address_street1"][1]

    assert_equal "Sopan Nagar", street
  end

  def test_savable_activity
    contact = Contact.new(created_by_user_id: 1, first_name: "John")
    contact.save

    contact.first_name = "Adam"
    assert contact.savable_activity?(contact.changes)

    changes = {}
    assert_not contact.savable_activity?(changes)

    changes = { "updated_at" => Time.current }
    assert_not contact.savable_activity?(changes)
  end

  def test_upgraded_contacts_count_gets_updated_for_grade_and_active_change
    user = users(:john)
    user.contacts.destroy_all

    Contact.create!(
      created_by_user_id: user.id,
      user_id: user.id
    )
    contact_for_grade_change = Contact.create!(
      created_by_user_id: user.id,
      user_id: user.id
    )
    assert_equal 2, user.reload.ungraded_contacts_count

    contact_for_grade_change.update(grade: 1)
    assert_equal 1, user.reload.ungraded_contacts_count
  end

  def test_recent_activities_contain_comment_activity
    contact = Contact.create!(created_by_user_id: 1)
    contact.comments.create(content: "New comment")

    assert contact.recent_activities.map(&:trackable_type).include?("Comment")
  end

  def test_recent_activities_contain_task_activity
    contact = Contact.create!(created_by_user_id: 1)
    contact.tasks.create(subject: "New task")

    assert contact.recent_activities.map(&:trackable_type).include?("Task")
  end

  def test_recent_activities_contain_contact_activity
    user = users(:john)
    contact = Contact.create!(created_by_user_id: 1)
    contact_activities = contact.contact_activities.create(
      subject: "New call referral activity",
      user: user,
      completed_at: Time.zone.now
    )
    contact_activities.save!

    assert contact.recent_activities.map(&:trackable_type).include?("ContactActivity")
  end

  def test_social_info_present_for_false
    user = users(:john)
    contact = Contact.create!(created_by_user_id: user.id)
    assert_not contact.social_info_present?
  end

  def test_social_info_present_for_true
    user = users(:john)
    contact = Contact.create!(created_by_user_id: user.id)

    [:suggested_first_name, :suggested_last_name,
     :suggested_location, :suggested_organization_name,
     :suggested_job_title, :suggested_linkedin_bio].each do |attr|
       contact.stubs(attr).returns("data")
     end

    assert contact.social_info_present?
  end

  def test_envelope_salutation_if_required_salutations_to_set_is_true
    user = users(:john)
    contact = Contact.new(created_by_user_id: user.id,
                          required_salutations_to_set: true,
                          first_name: "John",
                          last_name: "Williams",
                          spouse_first_name: "Lancy")
    contact.save

    assert_equal "John & Lancy Williams,", contact.envelope_salutation
    assert_equal "Dear John & Lancy,", contact.letter_salutation

    contact_2 = Contact.new(created_by_user_id: user.id,
                            required_salutations_to_set: true,
                            first_name: "John",
                            last_name: "Williams",
                            spouse_first_name: "Lancy",
                            spouse_last_name: "Dsouza")
    contact_2.save

    assert_equal "John Williams & Lancy Dsouza,", contact_2.envelope_salutation

    contact_3 = Contact.new(created_by_user_id: user.id,
                            required_salutations_to_set: true,
                            first_name: "John",
                            last_name: "Williams")
    contact_3.save

    assert_equal "John Williams,", contact_3.envelope_salutation
    assert_equal "Dear John,", contact_3.letter_salutation

    contact_4 = Contact.new(created_by_user_id: user.id,
                            required_salutations_to_set: true,
                            first_name: nil,
                            last_name: nil,
                            spouse_first_name: nil,
                            spouse_last_name: nil)
    contact_4.save

    assert_equal "", contact_4.envelope_salutation
    assert_equal "", contact_4.letter_salutation
  end

  def test_primary_phone_number
    phone_number1 = @contact.phone_numbers.create(number: "2144541111",
                                                  number_type: "Mobile",
                                                  primary: false)

    # If record is not found for primary then first record will be primay
    assert_equal phone_number1, @contact.primary_phone_number

    phone_number2 = @contact.phone_numbers.create(number: "2144542222",
                                                  number_type: "Mobile",
                                                  primary: true)

    assert_equal phone_number2, @contact.primary_phone_number
  end

  def test_primary_email_address
    email_address1 = @contact.email_addresses.create(email: "john+personal@example.com",
                                                     email_type: "Personal",
                                                     primary: false)

    # If record is not found for primary then first record will be primay
    assert_equal email_address1, @contact.primary_email_address

    email_address2 = @contact.email_addresses.create(email: "john+work@example.com",
                                                     email_type: "Work",
                                                     primary: true)

    assert_equal email_address2, @contact.primary_email_address
  end

  def test_creating_a_new_contact_should_have_only_one_activity
    assert_equal 1, @contact.recent_activities.count
  end

  def test_creating_a_new_contact_should_have_avatar_color
    assert @contact.avatar_color
  end

  def test_avatar_class
    @contact.update_columns(avatar_color: 9)
    assert_equal "abg9", @contact.avatar_class
    @contact.update_columns(avatar_color: nil)
    assert_equal "abg0", @contact.avatar_class
  end

  def test_name_method
    contact = Contact.create(created_by_user_id: 1, name: "John")
    assert_equal "John", contact.name

    contact.update(name: nil, first_name: "Alan", last_name: "Anderson")

    assert_equal "Alan Anderson", contact.name
  end

  def test_set_name_method
    assert_equal "John", @contact.set_name
  end

  def test_set_name_method_nil
    @contact.update_columns(first_name: nil, last_name: nil)
    assert_equal nil, @contact.set_name
  end

  def test_initials
    assert_equal "J", @contact.initials
    @contact.update_columns(last_name: "Smith")
    assert_equal "JS", @contact.initials
    @contact.update_columns(first_name: nil)
    assert_equal "S", @contact.initials
    @contact.update_columns(first_name: nil, last_name: nil)
    assert_equal "", @contact.initials
  end

  def test_initial
    assert_equal "J", @contact.initial
    @contact.update_columns(last_name: "Smith")
    assert_equal "J", @contact.initial
    @contact.update_columns(first_name: nil)
    assert_equal "S", @contact.initial
    @contact.update_columns(first_name: nil, last_name: nil)
    assert_equal nil, @contact.initial
  end

  def test_display_image
    image = images(:will_profile_image)
    image.update(attachable: @contact)
    assert_equal image, @contact.display_image
  end

  def test_display_image_shows_suggested_api_image
    Contact.any_instance.stubs(:contact_image).returns(false)
    Contact.any_instance.stubs(:api_suggested_image).returns(true)

    assert @contact.display_image
  end

  def test_grade_to_s
    assert_equal " ? ", @contact.grade_to_s
    @contact.update_columns(grade: 1)
    assert_equal "A", @contact.grade_to_s
    @contact.update_columns(grade: 2)
    assert_equal "B", @contact.grade_to_s
    @contact.update_columns(grade: 3)
    assert_equal "C", @contact.grade_to_s
    @contact.update_columns(grade: 4)
    assert_equal "D", @contact.grade_to_s
    @contact.update_columns(grade: 5)
    assert_equal "-", @contact.grade_to_s
  end

  def test_last_activity_completed
    assert_equal "call", @will.last_activity_completed.activity_type
  end

  def test_last_activity_completed_by_type
    assert_equal contact_activities(:john_call1), @will.last_activity_completed_by_type("call")
  end

  def test_last_called_at_to_s
    assert_equal "No calls made", @will.last_called_at_to_s
    @will.update_columns(last_called_at: Time.current)
    assert_equal Time.current.to_date.to_s(:cal_date), @will.reload.last_called_at_to_s
  end

  def test_last_note_sent_at_to_s
    assert_equal "No notes written", @will.last_note_sent_at_to_s
  end

  def test_last_visited_at_to_s
    assert_equal "No visits", @will.last_visited_at_to_s
  end

  def test_self_random_ungraded_contact
    random_contact = Contact.random_ungraded_contact(nil)
    assert_not_equal @will, random_contact
    assert_not_equal contacts(:john), random_contact
    assert_equal nil, random_contact.grade
  end

  def test_self_random_ungraded_contact_with_exclusion
    contact_to_exclude = contacts(:katie)
    random_contact = Contact.random_ungraded_contact(contact_to_exclude.id)
    assert_not_equal contact_to_exclude, random_contact
    assert_not_equal @will, random_contact
    assert_not_equal contacts(:john), random_contact
    assert_equal nil, random_contact.grade
  end

  def test_number_of_touches_ytd
    travel_to (Time.current + 6.hours) do
      @katie = contacts(:katie)

      @will.contact_activities.update_all(completed_at: Time.current - 1.year)
      @will.contact_activities.first(3).each { |ca| ca.update!(completed_at: Time.current - 2.hours) }

      @katie.contact_activities.update_all(completed_at: Time.current - 1.year)
      @katie.contact_activities.first(1).each { |ca| ca.update!(completed_at: Time.current - 2.hours) }

      assert_equal 3, @will.number_of_touches_ytd
      assert_equal 1, @katie.number_of_touches_ytd
    end
  end

  def test_primary_address
    assert_equal "59 Winthrop Rd", @will.primary_address.street
  end

  def test_all_emails
    assert_equal ["will@example.com"], @will.all_emails
  end

  def test_touch_frequency
    travel_to(Time.current)
    assert_equal 0, @will.touch_frequency

    contact_activities(:john_call2).update(completed_at: Time.current - 14.days)
    assert_equal 14, @will.touch_frequency
  end

  def test_contact_groups_by_user
    assert_equal [], @will.contact_groups_by_user(@nancy)
  end

  def test_mark_as_inactive
    travel_to(Time.current)
    assert_equal true, @will.mark_as_inactive!
    assert_equal false, @will.active
    assert_equal Time.current, @will.inactive_at
  end

  def test_self_find_from_email
    user = users(:john)
    email = "will@example.com"
    assert_equal @will, Contact.find_from_email(user, email)
  end

  def test_call_inboxapp
    token = users(:jane).nylas_token
    contact = contacts(:contact_with_real_inbox_email_messages)
    threads = contact.call_inboxapp(token)
    assert_not_nil threads
    assert_instance_of Inbox::Thread, threads.first
    assert_equal 454, threads.count
    assert(
      threads.first.participants.include?(john_smith_gmail),
      "Participants do not include john.smith.agentbright@gmail.com"
    )
  end

  def test_call_inboxapp_with_nil_token
    assert_equal nil, @will.call_inboxapp(nil)
  end

  def test_fetch_email_messages
    token = users(:jane).nylas_token
    contact = contacts(:contact_with_real_inbox_email_messages)
    messages = contact.fetch_email_messages(token)
    assert_not_nil messages
    assert_instance_of Inbox::Message, messages.first
    assert_equal 10, messages.count
  end

  def test_fetch_email_messages_with_nil_token
    assert_equal nil, @will.fetch_email_messages(nil)
  end

  def test_received_email_messages_total_count
    emails = create_emails_for(@will)
    assert_equal emails.count, @will.received_email_messages_total_count
  end

  def test_received_email_messages_in_last_year_count
    emails = create_emails_for(@will)
    datetime = DateTime.parse("Thu, 03 Nov 2016 04:41:28")
    update_for(emails, :received_at, datetime)
    assert_equal emails.count, @will.received_email_messages_in_last_year_count
  end

  def test_received_email_message_last_sent_at
    emails = create_emails_for(@will)
    datetime = DateTime.parse("Thu, 03 Nov 2016 04:41:28")
    update_for(emails, :received_at, datetime)
    Timecop.freeze(datetime) do
      assert_equal datetime, @will.last_received_email_sent_at
    end
  end

  def test_overall_last_contacted_at
    emails = create_emails_for(@will)
    datetime = DateTime.parse("Thu, 03 Nov 2016 04:41:28")
    update_for(emails, :received_at, datetime)
    Timecop.freeze(datetime) do
      assert_equal emails.last.received_at, @will.overall_last_contacted_at
    end
  end

  def test_received_email_messages_in_last_year_count_from_nylas
    beth = contacts :beth
    datetime = DateTime.parse("Thu, 03 Nov 2016 04:41:28")

    NylasApi::Message.any_instance.expects(:past_year).returns(1446922136)

    Timecop.freeze(datetime) do
      assert_equal 2, beth.received_email_messages_in_past_year_count_from_nylas
    end
  end

  def test_last_received_email_sent_at_from_nylas
    beth = contacts :beth

    datetime = DateTime.parse("Thu, 03 Nov 2016 04:41:28")
    Timecop.freeze(datetime) do
      assert beth.last_received_email_sent_at_from_nylas
    end
  end

  def test_overall_last_contacted_at_from_nylas
    beth = contacts :beth

    datetime = DateTime.parse("Thu, 03 Nov 2016 04:41:28")
    Timecop.freeze(datetime) do
      assert beth.overall_last_contacted_at_from_nylas
    end
  end

  def test_overall_last_contacted_at_from_nylas_for_last_contacted_date
    beth = contacts :beth

    datetime = DateTime.parse("Thu, 03 Nov 2016 04:41:28")
    beth.stubs(:last_contacted_date).returns(datetime)

    Timecop.freeze(datetime) do
      assert_equal datetime.localtime.to_s, beth.overall_last_contacted_at_from_nylas.localtime.to_s
    end
  end

  def test_phone_number
    assert_equal "0105551141", @will.phone_number
  end

  def test_valid_primary_email_address
    assert_equal true, @will.has_a_valid_primary_email_address?

    EmailAddress.any_instance.stubs(:email).returns(nil)
    assert_equal false, @will.has_a_valid_primary_email_address?

    Contact.any_instance.stubs(:primary_email_address).returns(nil)
    assert_equal false, @will.has_a_valid_primary_email_address?
  end

  def test_touch_frequency
    skip
    will = contacts(:will)
    assert_equal "", will.touch_frequency
  end

  private

  def addresses_attributes
    {
      "0" => {
        "street" => "Sopan Nagar",
        "city"   => "Pune",
        "state"  => "AL",
        "zip"    => "12322"
      }
    }
  end

  def john_smith_gmail
    { "email" => "john.smith.agentbright@gmail.com", "name" => "John Smith" }
  end

  def create_emails_for(contact, emails_count=2)
    user = contact.user
    emails = []

    user.stubs(:nylas_connected_email_account).returns('test@test.com')

    emails_count.times do
      emails << user.email_messages.create!(from_email: user.nylas_connected_email_account,
                                            to_email_addresses: [contact.email])
    end

    emails
  end

  def update_for(emails, attr, value)
    if emails.is_a? Array
      emails.each do |email|
        email.update_attribute(attr, value)
      end
    else
      emails.update_attribute(attr, value)
    end
  end
end
