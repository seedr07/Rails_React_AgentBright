class AddDisplayFieldsToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :displayed_price, :decimal
    add_column :leads, :displayed_commission_rate, :decimal
    add_column :leads, :displayed_gross_commission, :decimal
    add_column :leads, :displayed_closing_date_at, :datetime
  end
end
