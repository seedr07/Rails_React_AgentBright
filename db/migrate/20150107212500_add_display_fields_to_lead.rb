class AddDisplayFieldsToLead < ActiveRecord::Migration

  def change
    add_column :leads, :displayed_commission_type,     :string
    add_column :leads, :displayed_commission_fee,      :decimal
    add_column :leads, :displayed_referral_type,       :string
    add_column :leads, :displayed_referral_percentage, :string
    add_column :leads, :displayed_referral_fee,        :string
  end

end
