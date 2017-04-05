class ChangeCurrencyIntegersToDecimals < ActiveRecord::Migration
  def change
  	change_column :leads, :initial_agent_valuation, :decimal
  	change_column :leads, :initial_client_valuation, :decimal
  	change_column :leads, :current_price, :decimal
  	change_column :leads, :closing_price, :decimal
  	change_column :leads, :total_gross_commission, :decimal
  	change_column :leads, :min_price_range, :decimal
  	change_column :leads, :max_price_range, :decimal
  	change_column :leads, :referral_fees, :decimal
  	change_column :leads, :amount_owed, :decimal
  	change_column :leads, :estimated_gross_commission, :decimal
  	change_column :leads, :deal_value, :decimal
  	change_column :leads, :prequalification_amount, :decimal
  	remove_column :leads, :accepted_contract_price, :string
  	add_column :leads, :accepted_contract_price, :decimal
  end
end
