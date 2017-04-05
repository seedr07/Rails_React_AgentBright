require "test_helper"

class ContactActivityTest < ActiveSupport::TestCase

  fixtures :contact_activities, :contacts, :users

  def setup
    @user = users(:john)
    @contact = contacts(:will)
    travel_to Time.current
  end

  def test_set_last_activity_at
    contact_activity = ContactActivity.create(
      user: @user,
      contact: @contact,
      activity_type: "Call",
      completed_at: Time.current
    )
    assert_equal Time.current, contact_activity.contact.last_contacted_date
    assert_equal Time.current, contact_activity.contact.last_activity_at
  end

  def test_completed_this_week
    contact_activity = ContactActivity.create(
      user: @user,
      contact: @contact,
      activity_type: "Call",
      completed_at: Time.current
    )
    contact_activity2 = ContactActivity.create(
      user: @user,
      contact: @contact,
      activity_type: "Call",
      completed_at: Time.current - 360.days
    )
    assert_includes ContactActivity.completed_this_week("Call"), contact_activity
    assert_not_includes(
      ContactActivity.completed_this_week("Call"),
      contact_activity2
    )
  end

  def test_completed_this_year
    contact_activity = ContactActivity.create(
      user: @user,
      contact: @contact,
      activity_type: "Note",
      completed_at: Time.current
    )
    contact_activity2 = ContactActivity.create(
      user: @user,
      contact: @contact,
      activity_type: "Note",
      completed_at: Time.current - 1.year
    )

    assert_includes ContactActivity.completed_this_year, contact_activity
    assert_not_includes ContactActivity.completed_this_year, contact_activity2
  end

  def test_completed_today
    travel_to (Time.current + 6.hours) do
      contact_activity = ContactActivity.create(
        user: @user,
        contact: @contact,
        activity_type: "Note",
        completed_at: Time.current - 2.hours
      )
      contact_activity2 = ContactActivity.create(
        user: @user,
        contact: @contact,
        activity_type: "Note",
        completed_at: Time.current - 360.days
      )
      assert_includes ContactActivity.completed_today("Note"), contact_activity
      assert_not_includes ContactActivity.completed_today("Note"), contact_activity2
    end
  end

  def test_completed_yesterday
    contact_activity = ContactActivity.create(
      user: @user,
      contact: @contact,
      activity_type: "Visit",
      completed_at: Time.current - 1.day
    )
    contact_activity2 = ContactActivity.create(
      user: @user,
      contact: @contact,
      activity_type: "Visit",
      completed_at: Time.current - 5.days
    )
    assert_includes ContactActivity.completed_yesterday("Visit"), contact_activity
    assert_not_includes(
      ContactActivity.completed_yesterday("Visit"),
      contact_activity2
    )
  end

  def test_custom_time_getter
    contact_activity = ContactActivity.new
    assert_equal "Specify time...", contact_activity.custom_time
  end

  def test_custom_time_setter
    contact_activity = ContactActivity.create(
      user: @user,
      contact: @contact,
      activity_type: "Call",
      custom_time: "Just now"
    )
    assert_equal Time.current, contact_activity.completed_at
  end

end
