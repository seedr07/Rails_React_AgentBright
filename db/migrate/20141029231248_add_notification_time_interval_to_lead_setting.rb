class AddNotificationTimeIntervalToLeadSetting < ActiveRecord::Migration
  def change
    add_column :lead_settings, :notification_time_interval, :integer, default: 1
    add_column :lead_settings, :will_receive_morning_awaiting, :boolean, default: true
    add_column :lead_settings, :followup_lead_sms_permission, :boolean, default: true
    add_column :lead_settings, :followup_lead_email_permission, :boolean, default: true
  end
end
