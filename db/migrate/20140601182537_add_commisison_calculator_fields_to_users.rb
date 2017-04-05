class AddCommisisonCalculatorFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :commission_split_type, :string
    add_column :users, :agent_percentage_split, :decimal
    add_column :users, :broker_percentage_split, :decimal
    add_column :users, :monthly_broker_fees_paid, :decimal
    add_column :users, :annual_broker_fees_paid, :decimal
    add_column :users, :broker_fee_per_transaction, :decimal
    add_column :users, :broker_fee_alternative, :boolean
    add_column :users, :broker_fee_alternative_split, :decimal
    add_column :users, :per_transaction_fee_capped, :boolean
    add_column :users, :transaction_fee_cap, :integer
  end
end
