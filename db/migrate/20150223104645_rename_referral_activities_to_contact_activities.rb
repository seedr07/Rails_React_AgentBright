class RenameReferralActivitiesToContactActivities < ActiveRecord::Migration
  def change
    rename_table :referral_activities, :contact_activities
  end
end
