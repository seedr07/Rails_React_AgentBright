class AddLeadFollowupRemindersToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :lead_followup_reminder_time, :datetime
    add_column :leads, :lead_followup_reminder_attempted, :boolean, default: false
  end
end
