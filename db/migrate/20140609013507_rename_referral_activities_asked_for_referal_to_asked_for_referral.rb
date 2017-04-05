class RenameReferralActivitiesAskedForReferalToAskedForReferral < ActiveRecord::Migration
  def change
    change_column :referral_activities, :asked_for_referal, :boolean, :default => false
    rename_column :referral_activities, :asked_for_referal, :asked_for_referral
  end
end
