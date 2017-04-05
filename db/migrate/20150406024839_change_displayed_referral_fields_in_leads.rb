class ChangeDisplayedReferralFieldsInLeads < ActiveRecord::Migration

  def change
    change_column :leads, :displayed_referral_percentage, "decimal USING CAST(displayed_referral_percentage AS decimal)"
    change_column :leads, :displayed_referral_fee, "decimal USING CAST(displayed_referral_fee AS decimal)"
  end

end
