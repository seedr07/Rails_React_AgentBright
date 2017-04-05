class AddBrokerCommissionFieldsToLeads < ActiveRecord::Migration

  def change
    add_column :leads, :displayed_broker_commission_type, :string
    add_column :leads, :displayed_broker_commission_percentage, :decimal
    add_column :leads, :displayed_broker_commission_fee, :decimal
  end

end
