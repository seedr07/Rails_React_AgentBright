class NylasApi::Thread

  attr_reader :id, :account

  def initialize(token:, id: nil)
    @token = token
    @account = NylasApi::Account.new(@token).retrieve
    @id = id
  end

  def fetch
    thread_object
  end

  def find_by_email_address(email_address)
    if account && valid_email?(email_address)
      account.threads.where(any_email: email_address)
    end
  end

  def mark_as_read
    if thread_object
      thread_object.unread = false
      thread_object.save!
    end
  end

  def mark_as_unread
    if thread_object
      thread_object.unread = true
      thread_object.save!
    end
  end

  def participants
    extracted_participants = []
    thread_object.participants.each do |participant|
      if participant["email"] != NylasApi::Account.new(@token).email_address
        extracted_participants << participant
      end
    end
    extracted_participants
  end

  private

  def thread_object
    if account && id
      @thread_object ||= account.threads.find(id)
    end
  rescue Nylas::APIError => e
    Rails.logger.error "[NYLAS.message] Error finding thread: #{e}"
    return nil
  end

  def valid_email?(email)
    ValidateEmail.valid?(email)
  end

end
