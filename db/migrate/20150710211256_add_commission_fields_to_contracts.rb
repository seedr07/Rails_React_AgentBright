class AddCommissionFieldsToContracts < ActiveRecord::Migration
  def change
     add_column :contracts, :commission_percentage_total, :decimal
     add_column :contracts, :commission_percentage_buyer_side, :decimal
     add_column :contracts, :commission_fee_total, :decimal
     add_column :contracts, :commission_fee_buyer_side, :decimal
   end
end
