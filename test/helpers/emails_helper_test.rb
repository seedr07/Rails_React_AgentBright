require 'test_helper'

class EmailsHelperTest < ActionView::TestCase
  class DummyMessageForInbox
    def unread
      true
    end
  end

  def test_most_recent_message_index
    assert_equal 1, most_recent_message_index
  end

  def test_message_collapse_header_for_most_recent_message
    message_index = 1
    message = DummyMessageForInbox.new
    assert_equal '', message_collapse_header(message_index, message)
  end

  def test_message_collapse_header_for_second_read_message
    message_index = 2
    message = DummyMessageForInbox.new
    message.stubs(:unread).returns(false)

    assert_equal 'collapsed', message_collapse_header(message_index, message)
  end

  def test_message_collapse_header_for_any_unread_message
    message_index = 4
    message = DummyMessageForInbox.new

    assert_equal '', message_collapse_header(message_index, message)
  end

  def test_message_collapse_body_for_most_recent_message
    message_index = 1
    message = DummyMessageForInbox.new
    assert_equal 'collapse in', message_collapse_body(message_index, message)
  end

  def test_message_collapse_body_for_second_read_message
    message_index = 2
    message = DummyMessageForInbox.new
    message.stubs(:unread).returns(false)

    assert_equal 'collapse', message_collapse_body(message_index, message)
  end

  def test_message_collapse_body_for_unread_message
    message_index = 2
    message = DummyMessageForInbox.new

    assert_equal 'collapse in', message_collapse_body(message_index, message)
  end

end
