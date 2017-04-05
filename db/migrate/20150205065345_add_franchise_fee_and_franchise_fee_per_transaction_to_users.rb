class AddFranchiseFeeAndFranchiseFeePerTransactionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :franchise_fee, :boolean
    add_column :users, :franchise_fee_per_transaction, :decimal
  end
end
