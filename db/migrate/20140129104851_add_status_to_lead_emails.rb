class AddStatusToLeadEmails < ActiveRecord::Migration
  def change
    add_column :lead_emails, :importing_state, :string, default: :received
  end
end
