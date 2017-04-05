class AddLeadFollowupReminderTimeToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :lead_followup_reminder_time, :string
  end
end
