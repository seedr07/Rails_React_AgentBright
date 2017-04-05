class AddNotificationSettings < ActiveRecord::Migration
  def change
    add_column :lead_settings, :new_lead_sms_notification, :boolean, default: true
    add_column :lead_settings, :new_lead_email_notification, :boolean, default: true
    add_column :lead_settings, :lead_claimed_sms_notification, :boolean, default: true
    add_column :lead_settings, :lead_claimed_email_notification, :boolean, default: true
    add_column :lead_settings, :lead_unclaimed_sms_notification, :boolean, default: true
    add_column :lead_settings, :lead_unclaimed_email_notification, :boolean, default: true
  end
end
