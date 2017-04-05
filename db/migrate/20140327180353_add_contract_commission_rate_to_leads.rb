class AddContractCommissionRateToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :contract_commission_rate, :decimal
  end
end
