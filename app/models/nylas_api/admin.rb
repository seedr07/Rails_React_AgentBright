class NylasApi::Admin

  def initialize(account_id=nil)
    connect_to_nylas
    @account_id = account_id
  end

  def upgrade
    if account = @nylas.accounts.find(@account_id)
      result = account.upgrade!
      Rails.logger.info "[NYLAS.admin] Account #{@account_id} upgraded"
      result
    end
  end

  def downgrade
    if account = @nylas.accounts.find(@account_id)
      result = account.downgrade!
      Rails.logger.info "[NYLAS.admin] Account #{@account_id} downgraded"
      result
    end
  end

  private

  def connect_to_nylas
    @nylas ||= Nylas::API.new(
      Rails.application.secrets.nylas["id"],
      Rails.application.secrets.nylas["secret"],
      nil
    )
  rescue Inbox::APIError => e
    Rails.logger.warn "[NYLAS.admin] Error connecting to Nylas: #{e}"
    return nil
  end

end
