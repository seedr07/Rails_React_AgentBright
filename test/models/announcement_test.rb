require "test_helper"

class AnnouncementTest < ActiveSupport::TestCase

  fixtures :announcements

  def test_formatted_starts_at_is_nil
    announcement = Announcement.new
    assert_equal " ", announcement.formatted_starts_at
  end

  def test_formatted_starts_at_is_present
    announcement = Announcement.first
    assert_equal "Apr 30, 2014", announcement.formatted_starts_at
  end

  def test_formatted_ends_at_is_nil
    announcement = Announcement.new
    assert_equal " ", announcement.formatted_ends_at
  end

  def test_formatted_ends_at_is_present
    announcement = Announcement.first
    assert_equal "May 22, 2014", announcement.formatted_ends_at
  end

end
