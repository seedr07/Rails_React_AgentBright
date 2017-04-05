class GetUserOrContactFromMessageService
  def self.process(message, user, contact)
    emails = message.from.map { |h| h["email"]}

    if user.present? && emails.include?(user.nylas_connected_email_account)
      return user
    else
      contat_email_addresses = contact.email_addresses.map(&:email)
      contat_email_addresses = contat_email_addresses & emails

      return contact if contat_email_addresses.present?
    end
  end
end
