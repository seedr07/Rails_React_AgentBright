class CronJob < ActiveJob::Base

  queue_as :default

  INTERVAL = 5 # minutes

  after_perform do
    CronJob.schedule
  end

  def perform
    Rails.logger.info "[CronJob] Running..."
    run_lead_services
    run_email_services
    run_contact_services
    run_api_services
    Rails.logger.info "[CronJob] Complete."
  end

  def self.schedule
    return if CronJob.exist?
    delay = Rails.application.secrets.cron["delay_interval"].to_i
    delay = INTERVAL unless delay > 0
    CronJob.set(wait: delay.minutes).perform_later
  end

  def self.exist?
    Delayed::Job.
      where("handler like '%CronJob%'").
      where(locked_at: nil, failed_at: nil).
      exists?
  end

  private

  def run_lead_services
    UpdateMinutesSinceLastContactedService.new.perform
    LeadForwardingService.new.perform
    LeadBroadcastingService.new.perform
    LeadFollowupReminderService.new.notify
    UpdateLeadClientResponseService.new.update
    LeadUnsnoozingService.new.check_and_unsnooze_leads
  end

  def run_email_services
    UpdateMandrillMessagesService.new.update_mandrill_messages
    MandrillApiService.new.deliver_scheduled_email_campaigns
    NylasLeadEmailParsingService.new.perform
  end

  def run_contact_services
    ConnectWithContactService.new.perform
  end

  def run_api_services
    ApiResponseUpdateService.new.update_api_responses
  end

end
