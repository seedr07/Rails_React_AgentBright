class ConnectWithContactService

  DELAY_TIME = 1 * 24 * 60 # in minutes

  def perform
    contacts = list_of_contacts_who_should_be_contacted

    contacts.each do |contact|
      user = contact.user
      send_sms user, contact
      send_email user, contact
    end
  end

  private

  def list_of_contacts_who_should_be_contacted
    # contact everyone who has not been contacted in the last one day
    Contact.records_for_minutes_since_last_contacted(DELAY_TIME)
  end

  def send_sms user, contact
    payload = "This is a friendly reminder that it has been a while since you contacted #{contact.name}."
    SmsService.new.dispatch to: user.mobile_number, payload: payload #to_user: true, user_id: user.id, quiet_hours: user.lead_setting.quiet_hours
  end

  def send_email user, contact
    # email service is coming up
  end

end
