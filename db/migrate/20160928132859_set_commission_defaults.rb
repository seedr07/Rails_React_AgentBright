class SetCommissionDefaults < ActiveRecord::Migration[5.0]

  def change
    change_column :users, :broker_fee_alternative, :boolean, default: false
    change_column :users, :per_transaction_fee_capped, :boolean, default: false
  end

end
