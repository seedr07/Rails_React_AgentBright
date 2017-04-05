class AddAccountBalanceToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :account_balance, :float
  end
end
