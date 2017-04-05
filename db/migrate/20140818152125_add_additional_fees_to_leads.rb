class AddAdditionalFeesToLeads < ActiveRecord::Migration
 
  def change
    add_column :leads, :additional_fees, :decimal
  end

end
