class NylasApi::Message

  attr_reader :id, :account

  def initialize(token:, id: nil)
    Rails.logger.info "token: #{token}"
    @account = NylasApi::Account.new(token).retrieve
    @id = id
  end

  def fetch
    message_object
  end

  def find_by_email_address(email_address)
    if account && valid_email?(email_address)
      account.messages.where(any_email: email_address)
    end
  end

  def find_by_email_addresses(email_addresses)
    if account && email_addresses.present?
      account.messages.where(any_email: email_addresses.join(",")).range(0, 10)
    end
  end

  def mark_as_read
    if message_object
      message_object.unread = false
      message_object.save!
    end
  end

  def mark_as_unread
    if message_object
      message_object.unread = true
      message_object.save!
    end
  end

  def total_count(from:, to:)
    account.messages.where(from: from, to: to).count
  end

  def past_year_count(from:, to:)
    account.messages.where(from: from, to: to, received_after: past_year).count
  end

  def last_email_sent_at(from:, to:)
    last_email = account.messages.where(from: from, to: to).first
    return nil if last_email.nil?

    date_in_seconds = last_email.date
    DateTime.strptime(date_in_seconds.to_s,'%s')
  end

  def past_year
    1.year.ago.to_i
  end

  private

  def message_object
    if account && id
      Rails.logger.info "Account: #{account}"
      @message_object ||= account.messages.find(id)
    end
  rescue Nylas::APIError => e
    Rails.logger.error "[NYLAS.message] Error finding message: #{e}"
    return nil
  end

  def valid_email?(email)
    ValidateEmail.valid?(email)
  end

end
