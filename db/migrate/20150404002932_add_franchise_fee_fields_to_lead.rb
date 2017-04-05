class AddFranchiseFeeFieldsToLead < ActiveRecord::Migration

  def change
    add_column :leads, :displayed_broker_has_franchise_fee, :boolean, default: false, null: false
    add_column :leads, :displayed_broker_franchise_fee, :decimal
  end

end
