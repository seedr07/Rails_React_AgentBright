class AddFollowupLeadSmsPermissionFromLeadSetting < ActiveRecord::Migration
  def change
    add_column :lead_settings, :will_receive_morning_awaiting, :boolean, default: false
    add_column :lead_settings, :followup_lead_sms_permission, :boolean, default: false
    add_column :lead_settings, :followup_lead_email_permission, :boolean, default: false
  end
end
