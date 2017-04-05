class AddNextActionReminderSmsToLeadSettings < ActiveRecord::Migration

  def change
    add_column :lead_settings, :next_action_reminder_sms, :boolean, default: false, null: false
  end

end
