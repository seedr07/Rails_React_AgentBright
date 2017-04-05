require "test_helper"

class FullContactConnectorTest < ActiveSupport::TestCase

  def setup
    VCR.insert_cassette("full_contact_connector_test")
  end

  def teardown
    VCR.eject_cassette
  end

  def test_attempt_to_connect_with_no_email
    skip
    assert_equal 422, FullContactConnector.new(nil).status
  end

  def test_attempt_to_connect_with_invalid_email
    skip
    assert_equal 422, FullContactConnector.new("adsfasd").status
  end

  def test_attempt_to_connect_with_email_not_found
    skip
    assert_equal 200, FullContactConnector.new("ogradypatrickj+test1@gmail.com").status
  end

  def test_connect_to_fullcontact
    skip
    @full_contact = FullContactConnector.new("ogradypatrickj@gmail.com")
    assert_equal 200, @full_contact.status
    assert_equal "Patrick O'grady", @full_contact.contact_info.full_name
    assert_equal "Dayton, Ohio", @full_contact.demographics.location_general
    assert_equal "https://d2ojpxxtu63wzl.cloudfront.net/static/abd8adfd74ac00177f50e63e7fac225d_381de2fbefabfdbc3285dde300963098744ff88710643565e7d7c557b70a31cc", @full_contact.photo_url
    assert_equal 8, @full_contact.social_profiles.count
  end

end
