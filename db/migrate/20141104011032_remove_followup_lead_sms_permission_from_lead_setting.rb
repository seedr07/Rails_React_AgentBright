class RemoveFollowupLeadSmsPermissionFromLeadSetting < ActiveRecord::Migration
  def change
    remove_column :lead_settings, :will_receive_morning_awaiting, :boolean
    remove_column :lead_settings, :followup_lead_sms_permission, :boolean
    remove_column :lead_settings, :followup_lead_email_permission, :boolean
  end
end
