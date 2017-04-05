require "test_helper"

class NylasApi::ThreadTest < ActiveSupport::TestCase

  fixtures :users

  def setup
    @user = users(:jane)
    @token = @user.nylas_token
  end

  def test_initialize
    assert_nothing_raised do
      NylasApi::Thread.new(token: @token)
    end
  end

  def test_find_thread_by_id
    VCR.use_cassette("nylas_api/thread/find_thread_by_id") do
      assert_nothing_raised do
        thread = NylasApi::Thread.new(token: @token, id: valid_thread_id).fetch
        assert_equal valid_thread_id, thread.id
      end
    end
  end

  def test_find_thread_with_invalid_id
    VCR.use_cassette("nylas_api/thread/find_thread_with_invalid_id") do
      assert_nothing_raised do
        thread = NylasApi::Thread.new(token: @token, id: invalid_thread_id).fetch
        assert_nil thread
      end
    end
  end

  def test_find_with_invalid_token
    VCR.use_cassette("nylas_api/thread/find_with_invalid_token") do
      assert_nothing_raised do
        thread = NylasApi::Thread.new(
          token: "this_is_an_invalid_token",
          id: valid_thread_id
        ).fetch
        assert_nil thread
      end
    end
  end

  def test_find_by_email_address
    VCR.use_cassette("nylas_api/thread/find_by_email_address") do
      threads = NylasApi::Thread.new(token: @token).find_by_email_address("john@example.com")
      assert_equal 449, threads.count
    end
  end

  def test_find_by_email_address_with_invalid_email_address
    VCR.use_cassette("nylas_api/thread/invalid_email_address") do
      threads = NylasApi::Thread.new(token: @token).find_by_email_address("not_a_valid_email")
      assert_equal nil, threads
    end
  end

  def test_mark_thread_as_read_and_unread
    VCR.use_cassette("nylas_api/thread/mark_thread_as_read") do
      read_thread = NylasApi::Thread.new(token: @token, id: valid_thread_id)
      assert_equal false, read_thread.fetch.unread
      read_thread.mark_as_unread
      unread_thread = NylasApi::Thread.new(token: @token, id: valid_thread_id)
      assert_equal true, unread_thread.fetch.unread
      unread_thread.mark_as_read
      read_thread = NylasApi::Thread.new(token: @token, id: valid_thread_id)
      assert_equal false, read_thread.fetch.unread
    end
  end

  def test_destroy
    skip
    thread = NylasApi::Thread.new(token: @token, id: valid_thread_id)
    thread.destroy
    assert_equal nil, NylasApi::Thread.new(token: @token, id: valid_thread_id)
  end

  private

  def valid_thread_id
    "c95ltqqj9yxg8owimw4ccz1w2"
  end

  def invalid_thread_id
    "this_thread_id_is_invalid"
  end

end
