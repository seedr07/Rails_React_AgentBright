class AddFieldsToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :commission_type, :string
    add_column :contracts, :commission_rate, :decimal
    add_column :contracts, :commission_flat_fee, :decimal
    add_column :contracts, :referral_fee_type, :string
    add_column :contracts, :referral_fee_rate, :decimal
    add_column :contracts, :referral_fee_flat_fee, :decimal
    add_column :contracts, :additional_fees, :decimal
    add_column :contracts, :offer_deadline_at, :datetime
    add_column :contracts, :buyer, :string
    add_column :contracts, :buyer_agent, :string
    add_column :contracts, :seller, :string
    add_column :contracts, :seller_agent, :string
  end
end
