require "test_helper"
require "time"

class UserTest < ActiveSupport::TestCase

  fixtures :users, :teams, :teammates

  def setup
    @john = users :john
    @nancy = users :nancy
    @email_campaign_user = users :test_email_campaign_user
  end

  test 'admin is indeed admin' do
    user = users :admin
    assert user.super_admin?
  end

  test 'should assign generated agent bright email on create' do
    user = create_user

    assert_match /johnsmith\d+@/, user.ab_email_address
    assert_includes user.ab_email_address, Rails.application.secrets.leads["agent_bright_me_email_domain"]
  end

  test 'generated agent bright email should consist only of alphanumeric characters' do
    user = create_user(first_name: "Patrick", last_name: "O'Grady")
    assert_not_includes user.ab_email_address, ?'
    assert_includes user.ab_email_address, Rails.application.secrets.leads["agent_bright_me_email_domain"]
  end

  test 'should assign generated lead form key on create' do
    user = create_user
    assert user.lead_form_key
  end

  test 'generated lead form key consists only of alphanumeric characters' do
    user = create_user
    assert_no_match /[^[:alnum:]]/, user.lead_form_key
  end

  test "should allow valid website address formats" do
    valid_addresses = %w{http://yahoo.com https://yahoo.com  www.yahoo.com  http://www.yahoo.com }
    user = create_user
    valid_addresses.each do |web_address|
      user.personal_website = web_address
      assert user.valid?
    end
  end

  test "should report invalid website address formats" do
    user = create_user
    invalid_addresses = %w{sssyahoo invalidwebsite}
    invalid_addresses.each do |web_address|
      user.personal_website = web_address
      assert_equal false, user.valid?
    end
  end

  test "should not validate multiline website address" do
    user = create_user
    invalid_address = "javascript:exploit_code();/*\nhttp://yahoo.com\n*/"
    user.personal_website = invalid_address
    assert_equal false, user.valid?
  end

  test "should validate correct mobile number" do
    user = create_user
    user.mobile_number= users(:nancy).mobile_number
    assert user.save
    user.mobile_number= "123123123"
    refute user.save
  end


  test "should assign correct mobile number"  do
    user = create_user
    user.mobile_number= "860-227-7843"
    user.office_number= "860-767-8635 x16"
    assert user.save
  end

  test "initializes users name field based on first and last name" do
    user = create_user
    assert_equal "John Smith", user.name
  end

  test 'validates presence of required fields' do
    user = create_user
    [:first_name, :last_name, :ab_email_address].each do |field|
      field_value = user[field]
      user[field] = ""
      refute user.valid?
      user[field] = field_value
    end

  end

  test "should validate correct password" do
    user = create_user
    user.password = "welcome3"
    assert user.save
  end

  def test_team_member_ids_shows_only_approved_teammates
    assert_not_nil @john.team_owned
    assert_equal @john.team_member_ids, [@john.id]
    Teammate.where(team_id: @john.team_owned.id).update_all(status: 'teammate')
    assert_equal @john.team_member_ids, [@nancy.id, @john.id]
  end

  def test_user_not_in_quiet_hours_by_default
    user = create_user
    assert_not user.lead_setting.quiet_hours
    assert_not user.in_quiet_hours?
  end

  test "should not receieve daily overall recap email if the user opts out" do
    user = create_user
    users_count = User.for_daily_overall_recap.count

    lead_setting = user.build_lead_setting(daily_overall_recap: false)
    lead_setting.save

    assert_difference("ActionMailer::Base.deliveries.size", users_count - 1) do
      User.send_all_daily_overall_recap_emails
    end
  end

  def test_user_in_quiet_hours
    time = Time.parse("01:00")
    Time.zone.stubs(:now).returns(time)
    user = create_user
    lead_setting = user.lead_setting
    lead_setting.quiet_hours = true
    lead_setting.quiet_hours_start = 22
    lead_setting.quiet_hours_end = 8
    lead_setting.save!
    user.reload
    assert user.in_quiet_hours?, "User not in quiet hours. Current time: #{Time.zone.now}"
  end

  def test_user_not_in_quiet_hours
    time = Time.parse("15:00")
    Time.zone.stubs(:now).returns(time)
    user = create_user
    lead_setting = user.lead_setting
    lead_setting.quiet_hours = true
    lead_setting.quiet_hours_start = 22
    lead_setting.quiet_hours_end = 8
    lead_setting.save!
    assert_not user.in_quiet_hours?, "User IS in quiet hours."
  end

  def test_user_in_quiet_hours_when_start_less_than_end
    time = Time.parse("15:00")
    Time.zone.stubs(:now).returns(time)
    user = create_user
    lead_setting = user.lead_setting
    lead_setting.quiet_hours = true
    lead_setting.quiet_hours_start = 1
    lead_setting.quiet_hours_end = 8
    lead_setting.save
    # TODO - stub the current time as 1:00am
    assert_not user.in_quiet_hours?, "User IS in quiet hours."
  end

  def test_user_not_in_quiet_hours_when_start_equals_end
    time = Time.parse("12:00")
    Time.zone.stubs(:now).returns(time)
    user = create_user
    lead_setting = user.lead_setting
    lead_setting.quiet_hours = true
    lead_setting.quiet_hours_start = 12
    lead_setting.quiet_hours_end = 12
    lead_setting.save
    # TODO - stub the current time as 1:00am
    assert_not user.in_quiet_hours?, "User IS NOT in quiet hours."
  end

  def test_active_contacts_count
    user = create_user
    user.contacts.create(created_by_user_id: user.id)
    user.contacts.create(created_by_user_id: user.id)

    user.reload
    assert_equal 2, user.active_contacts_count

    contact = user.contacts.first
    contact.active = false
    contact.save

    user.reload
    assert_equal 1, user.active_contacts_count
  end

  def test_for_daily_overall_recaps_class_off_method
    user = create_user

    assert_equal 8, User.for_daily_overall_recap.count

    lead_setting = user.build_lead_setting(daily_overall_recap: false)
    lead_setting.save

    assert_equal 7, User.for_daily_overall_recap.count
  end

  def test_for_receive_daily_overall_recap
    users_count = User.for_daily_overall_recap.count
    assert_equal 7, users_count
  end

  def test_send_all_daily_overall_recap_emails
    users_count = User.for_daily_overall_recap.count
    assert_difference("ActionMailer::Base.deliveries.size", users_count) do
      User.send_all_daily_overall_recap_emails
    end
  end

  def test_send_next_action_reminder_sms
    assert @nancy.send_next_action_reminder_sms
  end

  def test_set_name_method
    user = create_user
    user.reload
    user.update(name: nil, first_name: "Alice", last_name: "Agent")

    assert_equal "Alice Agent", user.name
  end

  def test_pending_csv_file
    user = create_user
    assert_equal false, user.pending_csv_file?
    user.csv_files.create(state: "processing")
    assert_equal true, user.pending_csv_file?
  end

  private

  def create_user(options={})
    attributes = {
      email: "john2@example.com",
      password: "welcome1",
      first_name: "John",
      last_name: "Smith"
    }.merge(options)
    User.create! attributes
  end

end
