class AddNetCommissionToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :displayed_net_commission, :decimal
  end
end
