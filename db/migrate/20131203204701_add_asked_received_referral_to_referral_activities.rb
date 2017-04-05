class AddAskedReceivedReferralToReferralActivities < ActiveRecord::Migration
  def change
    add_column :referral_activities, :asked_for_referal, :boolean
    add_column :referral_activities, :received_referral, :boolean
  end
end
