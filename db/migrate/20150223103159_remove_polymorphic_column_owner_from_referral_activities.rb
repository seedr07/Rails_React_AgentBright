class RemovePolymorphicColumnOwnerFromReferralActivities < ActiveRecord::Migration
  def change
    remove_reference :referral_activities, :owner, polymorphic: true
  end
end
