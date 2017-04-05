require "test_helper"

class NylasApi::MessageTest < ActiveSupport::TestCase

  fixtures :users

  def setup
    @user = users(:jane)
    @token = @user.nylas_token
  end

  def test_initialize
    assert_nothing_raised do
      NylasApi::Message.new(token: @token)
    end
  end

  def test_find_message_by_id
    VCR.use_cassette("nylas_api/message/find_by_id") do
      assert_nothing_raised do
        message = NylasApi::Message.new(token: @token, id: valid_message_id).fetch
        assert_equal valid_message_id, message.id
      end
    end
  end

  def test_find_message_with_invalid_id
    VCR.use_cassette("nylas_api/message/find_message_with_invalid_id") do
      assert_nothing_raised do
        message = NylasApi::Message.new(token: @token, id: invalid_message_id).fetch
        assert_nil message
      end
    end
  end

  def test_find_with_invalid_token
    VCR.use_cassette("nylas_api/message/find_with_invalid_token") do
      assert_nothing_raised do
        message = NylasApi::Message.new(
          token: "this_is_an_invalid_token",
          id: valid_message_id
        ).fetch
        assert_nil message
      end
    end
  end

  def test_find_by_email_address
    VCR.use_cassette("nylas_api/message/find_by_email_address") do
      messages = NylasApi::Message.new(token: @token).find_by_email_address("john@example.com")
      assert_equal 567, messages.count
    end
  end

  def test_find_by_email_addresses
    contact = contacts(:beth)
    contact.email_addresses.create!(email: "annieogrady22+mcdonald@gmail.com")
    contact.email_addresses.create!(email: "santosh.wadghule+ruby@gmail.com")
    email_addresses = contact.all_emails

    recipient_email_addresses = []

    VCR.use_cassette("nylas_api/message/find_by_email_addresses") do
      messages = NylasApi::Message.new(token: @token).find_by_email_addresses(email_addresses)

      messages.each do |message|
        recipient_email_addresses << message.to[0]["email"]
      end
    end

    assert_includes email_addresses, "annieogrady22+mcdonald@gmail.com"
    assert_includes email_addresses, "santosh.wadghule+ruby@gmail.com"
  end

  def test_find_by_email_address_with_invalid_email_address
    VCR.use_cassette("nylas_api/message/find_by_email_address_with_invalid") do
      messages = NylasApi::Message.new(token: @token).find_by_email_address("not_a_valid_email")
      assert_equal nil, messages
    end
  end

  def test_mark_message_as_read_and_unread
    VCR.use_cassette("nylas_api/message/mark_message_as_read_and_unread") do
      read_message = NylasApi::Message.new(token: @token, id: valid_message_id)
      assert_equal false, read_message.fetch.unread
      read_message.mark_as_unread
      unread_message = NylasApi::Message.new(token: @token, id: valid_message_id)
      assert_equal true, unread_message.fetch.unread
      unread_message.mark_as_read
      read_message = NylasApi::Message.new(token: @token, id: valid_message_id)
      assert_equal false, read_message.fetch.unread
    end
  end

  private

  def valid_message_id
    "1sknddemgoyvq9hp5ikrsffew"
  end

  def invalid_message_id
    "this_message_id_is_invalid"
  end

end
