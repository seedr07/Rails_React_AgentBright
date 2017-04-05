class AddSubscriptionAccountStatusMarkedInactiveAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_account_status_marked_inactive_at, :datetime
  end
end
