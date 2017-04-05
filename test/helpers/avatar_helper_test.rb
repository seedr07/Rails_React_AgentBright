require "test_helper"
require "application_helper"
require_relative "../support/dummy_inbox_message"

class AvatarHelperTest < ActionView::TestCase

  include ApplicationHelper

  def setup
    @user = users(:john)
    @contact = contacts(:jane)
    @user_message = DummyInboxMessage.new(dummy_message_for_user)
    @contact_message = DummyInboxMessage.new(dummy_message_for_contact)
  end

  def test_display_user_avatar
    avatar = display_user_avatar(@user, 100, "circle")
    assert_match(/span/, avatar)
    assert_match(/circle/, avatar)
    assert_match(/initials\-100/, avatar)
    assert_match(@user.initials, avatar)
    assert_match(@user.avatar_class, avatar)

    User.any_instance.stubs(:profile_image).returns(images(:nancy_profile_image))
    avatar = display_user_avatar(@user, 100, "circle")
    assert_match(/user\-avatar/, avatar)
    assert_match(@user.profile_image_url, avatar)
  end

  def test_display_assigned_to_avatar
    avatar = display_assigned_to_avatar(@user)
    assert_match(/\<\/span\>/, avatar)
    assert_match(/assigned\-to\-avatar/, avatar)
    assert_match(/assigned\-to\-initials/, avatar)
    assert_match(@user.initials, avatar)

    User.any_instance.stubs(:profile_image).returns(images(:nancy_profile_image))
    avatar = display_assigned_to_avatar(@user)
    assert_match(/user\-avatar/, avatar)
    assert_match(@user.profile_image_url, avatar)
  end

  def test_display_initials_and_color_from_message_method_for_user
    @user.nylas_connected_email_account = "john@example.com"
    @user.avatar_color = Random.rand(12)
    @user.save

    value = display_initials_and_color_from_message(@user_message, @user, @contact)
    expected_value = "<span class='user-avatar #{@user.avatar_class}'>#{@user.initials.upcase}</span>"
    assert_equal expected_value, value
  end

  def test_display_initials_and_color_from_message_method_for_contact
    email_address = @contact.email_addresses.first
    email_address.email = "jane@example.com"
    email_address.save

    @contact.avatar_color = Random.rand(12)
    @contact.save

    value = display_initials_and_color_from_message(@contact_message, @user, @contact)
    expected_value = "<span class='user-avatar #{@contact.avatar_class}'>#{@contact.initials.upcase}</span>"

    assert_equal expected_value, value
  end

  def test_display_initials_and_color_from_message_method_for_not_matched
    email_address = @contact.email_addresses.first
    email_address.email = "jane+2@example.com"
    email_address.save

    @contact.avatar_color = Random.rand(12)
    @contact.save

    value = display_initials_and_color_from_message(@contact_message, @user, @contact)
    expected_value = "<span class='user-avatar abg0'>JS</span>"

    assert_equal expected_value, value
  end

  def test_display_user_circle
    circle = display_user_circle(@user)
    assert_match(/\<span/, circle)
    assert_match(/initials\-50/, circle)
    assert_match(@user.initials, circle)

    User.any_instance.stubs(:profile_image).returns(images(:nancy_profile_image))
    circle = display_user_circle(@user)
    assert_match(/\<img/, circle)
    assert_match(@user.profile_image_url, circle)
    assert_match(/avatar\-50/, circle)
  end

  private

  def dummy_message_for_user
    { "from" => [{ "email" => "john@example.com", "name" => "John Smith" }] }
  end

  def dummy_message_for_contact
    { "from" => [{ "email" => "jane@example.com", "name" => "Jane Smith" }] }
  end

end
