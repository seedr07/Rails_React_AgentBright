class AddContactToReferralActivities < ActiveRecord::Migration
  def change
    add_reference :referral_activities, :contact, index: true
  end
end
