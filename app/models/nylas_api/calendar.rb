class NylasApi::Calendar

  attr_reader :account

  def initialize(user)
    @user = user
    @account = NylasApi::Account.new(@user.nylas_token).retrieve
  end

  def all
    @account.calendars if @account
  end

  def recent_events
    seven_days_from_now = Time.current.beginning_of_day + 7.days
    if @account && @user.nilas_calendar_setting_id
      nylas_response = @account.events.where(
                         starts_after: Time.current.beginning_of_day.to_i,
                         ends_before: seven_days_from_now.to_i,
                         calendar_id: @user.nilas_calendar_setting_id,
                         expand_recurring: true
                       ).range(0, 9)

      convert_nylas_response_to_array(nylas_response)
    else
      []
    end
  end

  private

  def convert_nylas_response_to_array(nylas_response)
    array = []
    nylas_response.each do |response|
      array << response
    end
    array
  end

end
