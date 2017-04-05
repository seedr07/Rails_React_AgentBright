require 'test_helper'

class ApiResponseUpdateServiceTest < ActiveSupport::TestCase
  fixtures :users, :contacts

  def setup
    @will = contacts(:will)
    @jane = contacts(:jane)
    @nancy = users(:nancy)
    @api = ApiResponseUpdateService.new
    @api_response = ApiResponse.new(api_type: "fullcontact.ping",
                                    api_called_at: (Time.zone.now - 2.days),
                                    status: "200",
                                    message: "200 pings left this month").save
  end

  def test_update_api_responses
    result = @api.update_api_responses
    assert_not_nil result
  end

  def test_update_fullcontact_api_response
    result = @api.update_fullcontact_api_response(ApiResponse.new)
    assert_not_nil result
  end

  def test_time_to_ping_fullcontact?
    result = @api.time_to_ping_fullcontact?
    assert_equal result, true
  end
end