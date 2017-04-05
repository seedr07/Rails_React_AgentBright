class AddLeadFollowupReminderAttemptedToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :lead_followup_reminder_attempted, :boolean
  end
end
