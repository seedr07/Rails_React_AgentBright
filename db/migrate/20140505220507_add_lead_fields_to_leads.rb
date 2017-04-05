class AddLeadFieldsToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :incoming_lead_address, :string
    add_column :leads, :incoming_lead_city, :string
    add_column :leads, :incoming_lead_state, :string
    add_column :leads, :incoming_lead_zip, :string
    add_column :leads, :incoming_lead_price, :integer, default: 0
    add_column :leads, :incoming_lead_mls, :string
    add_column :leads, :incoming_lead_url, :string
    add_column :leads, :incoming_lead_message, :string
  end
end
