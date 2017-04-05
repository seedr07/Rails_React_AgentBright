class AddRepliedToReferralActivities < ActiveRecord::Migration

  def change
    add_column :referral_activities, :replied_to, :boolean, default: false
  end

end
