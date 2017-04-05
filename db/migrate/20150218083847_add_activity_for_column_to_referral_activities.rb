class AddActivityForColumnToReferralActivities < ActiveRecord::Migration
  def change
    add_column :referral_activities, :activity_for, :string
  end
end
