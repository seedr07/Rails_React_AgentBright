require "test_helper"

class ActivitiesHelperTest < ActionView::TestCase

  def test_activity_icon
    icon_html = activity_icon("blue", "mdi-snowball")
    assert_match(/mdi\-snowball/, icon_html)
  end

  def test_showable_new_activity_stream_method
    assert showable_new_activity_stream?("leads", "show")
    assert showable_new_activity_stream?("leads", "show_lead")
    assert showable_new_activity_stream?("contacts", "show")

    assert_not showable_new_activity_stream?("wrong", "wrong")
  end

end
