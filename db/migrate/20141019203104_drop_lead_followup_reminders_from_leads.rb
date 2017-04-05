class DropLeadFollowupRemindersFromLeads < ActiveRecord::Migration
  def change
    remove_column :leads, :lead_followup_reminder_time, :string
    remove_column :leads, :lead_followup_reminder_attempted, :boolean
  end
end
