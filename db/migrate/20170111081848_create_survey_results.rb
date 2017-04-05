class CreateSurveyResults < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_results do |t|
      t.boolean :completed, default: false
      t.string :survey_token
      t.string :browser
      t.string :platform
      t.datetime :started_at
      t.datetime :finished_at
      t.string :user_agent
      t.string :referer
      t.string :network_id
      t.text :promotion_code
      t.text :first_name
      t.text :last_name
      t.text :email
      t.integer :zip_code
      t.integer :years_experience
      t.string :workload
      t.text :other_work, array: :true, default: []
      t.integer :average_home_price
      t.integer :past_year_total_transaction
      t.integer :past_year_income
      t.string :next_year_plans
      t.integer :desired_annual_income
      t.integer :est_business_expenses
      t.boolean :pays_monthly_broker_fee
      t.integer :monthly_broker_fees_paid
      t.boolean :franchise_fee
      t.decimal :franchise_fee_per_transaction
      t.string :commission_split_type
      t.decimal :agent_percentage_split
      t.integer :broker_fee_per_transaction
      t.boolean :broker_fee_alternative
      t.decimal :broker_fee_alternative_split
      t.boolean :per_transaction_fee_capped
      t.integer :transaction_fee_cap

      t.timestamps
    end
  end
end
