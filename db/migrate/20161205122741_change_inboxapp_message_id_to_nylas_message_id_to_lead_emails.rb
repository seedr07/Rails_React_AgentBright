class ChangeInboxappMessageIdToNylasMessageIdToLeadEmails < ActiveRecord::Migration[5.0]
  def change
    rename_column :lead_emails, :inboxapp_message_id, :nylas_message_id
  end
end
