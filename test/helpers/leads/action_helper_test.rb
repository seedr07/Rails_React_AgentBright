require "test_helper"

class Leads::ActionHelperTest < ActionView::TestCase

  fixtures :leads, :contact_activities, :tasks

  def setup
    @lead = leads(:katie)
  end

  def test_display_action_glyphicon_call
    Util.log "Leads: #{Lead.count} | Contacts: #{Contact.count} | Contact Activities: #{ContactActivity.count} | Tasks: #{Task.count}"
    ContactActivity.any_instance.stubs(:activity_type).returns("Call")
    assert_equal(
      "<i class=\"mdi-communication-phone\"></i>",
      display_action_glyphicon(@lead)
    )
  end

  def test_display_action_glypicon_note
    Util.log "Leads: #{Lead.count} | Contacts: #{Contact.count} | Contact Activities: #{ContactActivity.count} | Tasks: #{Task.count}"
    ContactActivity.any_instance.stubs(:activity_type).returns("Note")
    assert_equal(
      "<i class=\"mdi-content-mail\"></i>",
      display_action_glyphicon(@lead)
    )
  end

  def test_display_action_glypicon_visit
    Util.log "Leads: #{Lead.count} | Contacts: #{Contact.count} | Contact Activities: #{ContactActivity.count} | Tasks: #{Task.count}"
    ContactActivity.any_instance.stubs(:activity_type).returns("Visit")
    assert_equal(
      "<i class=\"mdi-social-group\"></i>",
      display_action_glyphicon(@lead)
    )
  end

  def test_display_action_glypicon_meeting
    Util.log "Leads: #{Lead.count} | Contacts: #{Contact.count} | Contact Activities: #{ContactActivity.count} | Tasks: #{Task.count}"
    ContactActivity.any_instance.stubs(:activity_type).returns("Meeting")
    assert_equal(
      "<i class=\"mdi-social-group\"></i>",
      display_action_glyphicon(@lead)
    )
  end

  def test_display_action_glypicon_lunch
    Util.log "Leads: #{Lead.count} | Contacts: #{Contact.count} | Contact Activities: #{ContactActivity.count} | Tasks: #{Task.count}"
    ContactActivity.any_instance.stubs(:activity_type).returns("Lunch")
    assert_equal(
      "<i class=\"mdi-maps-restaurant-menu\"></i>",
      display_action_glyphicon(@lead)
    )
  end

  def test_display_action_glypicon_task
    Util.log "Leads: #{Lead.count} | Contacts: #{Contact.count} | Contact Activities: #{ContactActivity.count} | Tasks: #{Task.count}"
    Lead.any_instance.stubs(:most_recent_contact_activity).returns(nil)
    assert_equal(
      "<i class=\"mdi-action-done\"></i>",
      display_action_glyphicon(@lead)
    )
  end

end
