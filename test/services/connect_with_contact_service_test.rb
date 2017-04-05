require 'test_helper'

class ConnectWithContactServiceTest < ActiveSupport::TestCase

  fixtures :users

  # at this time not getting any exception is good enough test.
  # it will be improvised later
  def test_perform
    Contact.create! last_contacted_at: 40.days.ago, created_by_user: User.first,  user: User.first, first_name: 'Joe', email_addresses_attributes: [email: 'a@example.com']
    UpdateMinutesSinceLastContactedService.new.perform
    ConnectWithContactService.new.perform
  end

end
