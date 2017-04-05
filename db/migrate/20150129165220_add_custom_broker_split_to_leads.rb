class AddCustomBrokerSplitToLeads < ActiveRecord::Migration

  def change
    add_column :leads, :displayed_broker_commission_custom, :boolean, default: false
  end

end
