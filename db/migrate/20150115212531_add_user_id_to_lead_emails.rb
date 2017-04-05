class AddUserIdToLeadEmails < ActiveRecord::Migration
  def change
    add_column :lead_emails, :user_id, :integer
  end
end
