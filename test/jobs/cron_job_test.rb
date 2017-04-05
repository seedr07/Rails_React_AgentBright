require "test_helper"

class CronJobTest < ActiveJob::TestCase

  def test_cron_job_scheduling
    CronJob.schedule
    assert_enqueued_jobs 1
  end

  def test_cron_job_exists
    assert_no_enqueued_jobs do
      CronJob.expects(:exist?).returns(true)
      assert_equal(nil, CronJob.schedule)
    end
  end

  def test_cron_job
    assert_no_enqueued_jobs
    assert_enqueued_jobs 1 do
      mock_services
      CronJob.perform_now
    end
  end

  private

  def cron_jobs
    Delayed::Job.
      where("handler like '%CronJob%'").
      where(locked_at: nil, failed_at: nil)
  end

  def mock_services
    minutes_service = mock
    minutes_service.expects(:perform).returns(:successfully_performed)
    UpdateMinutesSinceLastContactedService.expects(:new).returns(minutes_service)

    lead_forwarding_service = mock
    lead_forwarding_service.expects(:perform).returns(:successfully_performed)
    LeadForwardingService.expects(:new).returns(lead_forwarding_service)

    lead_broadcasting_service = mock
    lead_broadcasting_service.expects(:perform).returns(:successfully_performed)
    LeadBroadcastingService.expects(:new).returns(lead_broadcasting_service)

    follow_up_service = mock
    follow_up_service.expects(:notify).returns(:successfully_notified)
    LeadFollowupReminderService.expects(:new).returns(follow_up_service)

    update_response_service = mock
    update_response_service.expects(:update).returns(:successfully_updated)
    UpdateLeadClientResponseService.expects(:new).returns(update_response_service)

    unsnooze_service = mock
    unsnooze_service.expects(:check_and_unsnooze_leads).returns(:successfully_checked_and_unsnoozed)
    LeadUnsnoozingService.expects(:new).returns(unsnooze_service)

    mandrill_message_service = mock
    mandrill_message_service.expects(:update_mandrill_messages).returns(:successfully_updated)
    UpdateMandrillMessagesService.expects(:new).returns(mandrill_message_service)

    mandrill_api_service = mock
    mandrill_api_service.expects(:deliver_scheduled_email_campaigns).returns(:successfully_delivered)
    MandrillApiService.expects(:new).returns(mandrill_api_service)

    email_parsing_service = mock
    email_parsing_service.expects(:perform).returns(:successfully_performed)
    NylasLeadEmailParsingService.expects(:new).returns(email_parsing_service)

    contact_connect_service = mock
    contact_connect_service.expects(:perform).returns(:successfully_performed)
    ConnectWithContactService.expects(:new).returns(contact_connect_service)

    api_response_service = mock
    api_response_service.expects(:update_api_responses).returns(:successfully_updated)
    ApiResponseUpdateService.expects(:new).returns(api_response_service)
  end

end
