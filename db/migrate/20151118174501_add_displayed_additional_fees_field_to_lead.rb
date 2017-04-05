class AddDisplayedAdditionalFeesFieldToLead < ActiveRecord::Migration

  def change
    add_column :leads, :displayed_additional_fees, :decimal
  end

end
