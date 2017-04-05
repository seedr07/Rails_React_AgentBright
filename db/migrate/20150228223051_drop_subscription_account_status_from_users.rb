class DropSubscriptionAccountStatusFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :subscription_account_status, :integer
  end
end
