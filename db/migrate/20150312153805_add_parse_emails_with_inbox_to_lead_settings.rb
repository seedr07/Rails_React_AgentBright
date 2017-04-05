class AddParseEmailsWithInboxToLeadSettings < ActiveRecord::Migration
  def change
    add_column :lead_settings, :parse_emails_with_inbox, :boolean, default: false
  end
end
