class AddOwnerToReferralActivity < ActiveRecord::Migration

  def change
    add_reference :referral_activities, :owner, polymorphic: true, index: true
  end

end
