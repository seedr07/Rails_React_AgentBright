require "test_helper"

class FullContactInfoUpdaterTest < ActiveSupport::TestCase

  fixtures :contacts

  def setup
    VCR.insert_cassette("full_contact_info_updater_test")
    @contact = contacts(:patrick)
  end

  def teardown
    VCR.eject_cassette
  end

  def test_attempt_to_connect_with_no_email
    @contact.primary_email_address.destroy!
    updater = FullContactInfoUpdater.new(@contact.id)
    updater.update_all
    assert_equal "Search error", updater.contact.search_status
  end

  def test_connect_and_update
    updater = FullContactInfoUpdater.new(@contact.id)
    updater.update_all_and_save
    @contact.reload
    assert_equal "Our API has found some information about this person", @contact.search_status
    assert_equal "Dayton, Ohio, United States", @contact.suggested_location
    assert @contact.api_suggested_image, "API Suggested Image record not found"
    assert_equal "Patrick", @contact.suggested_first_name
    assert_equal "O'grady", @contact.suggested_last_name
  end

  def test_connect_to_fullcontact
    @full_contact = FullContactConnector.new("ogradypatrickj@gmail.com")
    assert_equal 200, @full_contact.status
    assert_equal "Patrick O'grady", @full_contact.contact_info.full_name
    assert_equal "Dayton, Ohio", @full_contact.demographics.location_general
    assert_equal "https://d2ojpxxtu63wzl.cloudfront.net/static/abd8adfd74ac00177f50e63e7fac225d_381de2fbefabfdbc3285dde300963098744ff88710643565e7d7c557b70a31cc", @full_contact.photo_url
    assert_equal 8, @full_contact.social_profiles.count
  end

end
