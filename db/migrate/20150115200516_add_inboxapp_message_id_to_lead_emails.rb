class AddInboxappMessageIdToLeadEmails < ActiveRecord::Migration
  def change
    add_column :lead_emails, :inboxapp_message_id, :string
  end
end
