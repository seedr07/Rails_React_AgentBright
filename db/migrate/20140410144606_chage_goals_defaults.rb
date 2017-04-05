class ChageGoalsDefaults < ActiveRecord::Migration
  def change
    change_column :goals, :referrals_for_one_close, :decimal, :default => 5
    change_column :goals, :contacts_to_generate_one_referral, :decimal, :default => 20
  end
end
