class CreateReferralActivities < ActiveRecord::Migration
  def change
    create_table :referral_activities do |t|
      t.string :activity_type
      t.string :subject
      t.datetime :completed_at
      t.text :comments

      t.timestamps
    end
  end
end
