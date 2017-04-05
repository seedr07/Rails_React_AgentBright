class AddReferralTypeAndFlatFeeToLeads < ActiveRecord::Migration
  
  def change
    add_column :leads, :referral_fee_type, :string
    add_column :leads, :referral_fee_rate, :decimal
    add_column :leads, :referral_fee_flat_fee, :decimal

    add_column :properties, :referral_fee_type, :string
    add_column :properties, :referral_fee_rate, :decimal
    add_column :properties, :referral_fee_flat_fee, :decimal
  end

end
