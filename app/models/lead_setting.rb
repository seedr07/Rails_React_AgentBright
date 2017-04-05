# == Schema Information
#
# Table name: lead_settings
#
#  auto_respond_body                   :text
#  auto_respond_subject                :string
#  away                                :boolean          default(FALSE)
#  broadcast_after_minutes             :integer          default(5)
#  broadcast_lead_to_group             :boolean          default(FALSE)
#  created_at                          :datetime
#  daily_leads_recap                   :boolean          default(TRUE)
#  daily_overall_recap                 :boolean          default(TRUE)
#  daily_pipeline                      :boolean          default(TRUE)
#  email_auto_respond                  :boolean          default(TRUE)
#  followup_lead_email_permission      :boolean          default(FALSE)
#  followup_lead_sms_permission        :boolean          default(FALSE)
#  forward_after_minutes               :integer          default(0)
#  forward_lead_to_group               :boolean          default(FALSE)
#  id                                  :integer          not null, primary key
#  lead_claimed_email_notification     :boolean          default(TRUE)
#  lead_claimed_sms_notification       :boolean          default(TRUE)
#  lead_unclaimed_email_notification   :boolean          default(TRUE)
#  lead_unclaimed_sms_notification     :boolean          default(TRUE)
#  new_lead_email_notification         :boolean          default(TRUE)
#  new_lead_sms_notification           :boolean          default(TRUE)
#  next_action_reminder_sms            :boolean          default(FALSE), not null
#  notification_time_interval          :integer          default(1)
#  parse_emails_with_inbox             :boolean          default(FALSE)
#  parse_realtor_leads                 :boolean          default(TRUE)
#  parse_trulia_leads                  :boolean          default(TRUE)
#  parse_zillow_leads                  :boolean          default(TRUE)
#  quiet_hours                         :boolean          default(FALSE)
#  quiet_hours_end                     :integer
#  quiet_hours_start                   :integer
#  receive_daily_client_activity_recap :boolean
#  receive_sms_on_weekends             :boolean          default(TRUE)
#  updated_at                          :datetime
#  user_id                             :integer
#  vacation_end_at                     :datetime
#  will_receive_morning_awaiting       :boolean          default(FALSE)
#
# Indexes
#
#  index_lead_settings_on_user_id  (user_id)
#

class LeadSetting < ActiveRecord::Base

  TIME_TO_HOURS = {
    "12:00am" => 0,
    "1:00am" => 1,
    "2:00am" => 2,
    "3:00am" => 3,
    "4:00am" => 4,
    "5:00am" => 5,
    "6:00am" => 6,
    "7:00am" => 7,
    "8:00am" => 8,
    "9:00am" => 9,
    "10:00am" => 10,
    "11:00am" => 11,
    "12:00pm" => 12,
    "1:00pm" => 13,
    "2:00pm" => 14,
    "3:00pm" => 15,
    "4:00pm" => 16,
    "5:00pm" => 17,
    "6:00pm" => 18,
    "7:00pm" => 19,
    "8:00pm" => 20,
    "9:00pm" => 21,
    "10:00pm" => 22,
    "11:00pm" => 23,
  }.freeze

  NOTIFICATION_TIME_INTERVAL = {
    "1 hour" => 1,
    "2 hours" => 2,
    "4 hours" => 4,
    "8 hours" => 8,
    "24 hours" => 24,
  }.freeze

  belongs_to :user
  has_and_belongs_to_many :forward_to_group, class_name: "LeadGroup"
  has_and_belongs_to_many :broadcast_to_group, class_name: "LeadGroup", join_table: "lead_group_broadcast_settings"

  def toggle_auto_responder
    self.toggle(:email_auto_respond)
    save!
  end

  def toggle_forward_to_lead_group
    self.toggle(:forward_lead_to_group)
    save!
  end

  def toggle_broadcast_to_lead_group
    self.toggle(:broadcast_lead_to_group)
    save!
  end

  def send_auto_respond_email?(leads_email)
    # Only one lead record present.
    self.email_auto_respond? && leads_email.present? &&
      (Contact.by_user_and_email(user, leads_email).count < 2)
  end

  def auto_respond_email_subject_text
    if self.auto_respond_subject.present?
      self.auto_respond_subject
    else
      "Thanks for getting in touch!"
    end
  end

  def toggle_lead_parser_status(source)
    lead_source = source.to_s.strip.downcase
    if Lead::LEAD_SOURCES.include? lead_source
      self.toggle("parse_#{lead_source}_leads")
      save!
    else
      false
    end
  end

  def lead_source_active?(source)
    lead_source = source.to_s.strip.downcase
    if respond_to? "parse_#{lead_source}_leads?"
      public_send "parse_#{lead_source}_leads?".to_sym
    else
      false
    end
  end

  def forwarding_off?
    !forward_lead_to_group? && !broadcast_lead_to_group?
  end

end
