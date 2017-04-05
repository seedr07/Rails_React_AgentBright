class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.decimal :desired_annual_income
      t.decimal :est_business_expenses
      t.decimal :portion_of_agent_split
      t.decimal :gross_commission_goal
      t.decimal :avg_commission_rate
      t.decimal :gross_sales_vol_required
      t.decimal :avg_price_in_area
      t.decimal :annual_transaction_goal
      t.decimal :qtrly_transaction_goal
      t.decimal :referrals_for_one_close,  :default => 5
      t.decimal :contacts_to_generate_one_referral,  :default => 20
      t.decimal :contacts_need_per_month
      t.decimal :calls_required_wkly
      t.decimal :note_required_wkly
      t.string :visits_required_wkly

      t.timestamps
    end
  end
end
