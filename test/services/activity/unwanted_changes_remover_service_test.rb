require "test_helper"

class Activity::UnwantedChangesRemoverServiceTest < ActiveSupport::TestCase
  def test_perform
    activity_changes = changes_for_contact_with_address_and_phone
    required_activity_changes = Activity::UnwantedChangesRemoverService.
                                 new(activity_changes).
                                 perform

    assert_not required_activity_changes.keys.include?("created_at")
    assert_not required_activity_changes.keys.include?("updated_at")
    assert_not required_activity_changes.keys.include?("user_id")
    assert_not required_activity_changes.keys.include?("created_by_user_id")

    activity_changes = { "updated_at" => Time.current }
    required_activity_changes = Activity::UnwantedChangesRemoverService.
                                 new(activity_changes).
                                 perform

    assert required_activity_changes.keys.blank?

    activity_changes = { some_key: [nil, ""] }
    required_activity_changes = Activity::UnwantedChangesRemoverService.
                                 new(activity_changes).
                                 perform

    assert required_activity_changes.keys.blank?

    activity_changes = { some_id: [nil, 1] }
    required_activity_changes = Activity::UnwantedChangesRemoverService.
                                 new(activity_changes).
                                 perform

    assert required_activity_changes.keys.blank?
  end

  private

  def changes_for_contact_with_address_and_phone
    {
      "first_name"          => [nil, "John"],
      "last_name"           => [nil, "Jones"],
      "spouse_first_name"   => [nil, "Lila"],
      "spouse_last_name"    => [nil, "Jones"],
      "grade"               => [nil, 2],
      "envelope_salutation" => [nil, "John & Liala Jones,"],
      "letter_salutation"   => [nil, "Dear John & Liala Jones,"],
      "company"             => [nil, ""],
      "profession"          => [nil, ""],
      "title"               => [nil, ""],
      "user_id"             => [nil, 1],
      "created_by_user_id"  => [nil, 1],
      "city1"               => [nil, "2344"],
      "state1"              => [nil, "AL"],
      "zip1"                => [nil, "23444"],
      "street1"             => [nil, "Hi2344"],
      "owner_type1"         => [nil, "Contact"],
      "number1"             => [nil, "3444344444"],
      "number_type1"        => [nil, "Mobile"],
      "email1"              => [nil, "john@example.com"],
      "email_type1"         => [nil, "Primary"],
      "created_at"          => [nil, "Tue, 09 Dec 2014 10:09:05 EST -05:00"],
      "updated_at"          => [nil, "Tue, 09 Dec 2014 10:09:05 EST -05:00"],
      "avatar_color"        => [0, 1]
    }
  end
end
