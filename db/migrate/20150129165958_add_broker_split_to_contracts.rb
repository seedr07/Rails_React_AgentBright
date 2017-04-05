class AddBrokerSplitToContracts < ActiveRecord::Migration

  def change
    add_column :contracts, :broker_commission_custom, :boolean, default: false
    add_column :contracts, :broker_commission_type, :string
    add_column :contracts, :broker_commission_percentage, :decimal
    add_column :contracts, :broker_commission_fee, :decimal
  end

end
