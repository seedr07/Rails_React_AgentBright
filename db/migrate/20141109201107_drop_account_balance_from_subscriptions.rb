class DropAccountBalanceFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :account_balance, :integer
  end
end
