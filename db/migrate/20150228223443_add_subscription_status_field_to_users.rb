class AddSubscriptionStatusFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_account_status, :integer, default: 1
  end
end
