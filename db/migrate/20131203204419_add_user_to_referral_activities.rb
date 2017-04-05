class AddUserToReferralActivities < ActiveRecord::Migration
  def change
    add_reference :referral_activities, :user, index: true
  end
end
