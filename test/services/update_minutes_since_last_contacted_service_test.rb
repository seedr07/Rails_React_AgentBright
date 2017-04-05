require 'test_helper'

class UpdateMinutesSinceLastContactedServiceTest < ActiveSupport::TestCase

  fixtures :users

  def setup
    Contact.delete_all
  end

  def test_perform
    contact = Contact.create! last_contacted_at: 4.hours.ago, user: User.first, created_by_user: User.first, first_name: 'Joe', email_addresses_attributes: [email: 'a@example.com']
    UpdateMinutesSinceLastContactedService.new.perform
    assert_equal 240, contact.reload.minutes_since_last_contacted
  end

end
