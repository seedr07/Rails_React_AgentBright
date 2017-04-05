class AddSubscriptionAccountStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_account_status, :integer, default: 999
  end
end
