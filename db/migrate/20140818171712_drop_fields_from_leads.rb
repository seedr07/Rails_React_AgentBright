class DropFieldsFromLeads < ActiveRecord::Migration
  
  def change
    remove_column :leads, :initial_agent_valuation, :decimal
    remove_column :leads, :initial_client_valuation, :decimal
    remove_column :leads, :current_price, :decimal
    remove_column :leads, :closing_price, :decimal
    remove_column :leads, :closing_date_at, :datetime
    remove_column :leads, :total_commission_percentage, :decimal
    remove_column :leads, :agent_commission_percentage, :decimal
    remove_column :leads, :total_gross_commission, :decimal
    remove_column :leads, :initial_property_interested_in, :string
    remove_column :leads, :mls_id, :string
    remove_column :leads, :listing_address, :text
    remove_column :leads, :listing_city, :string
    remove_column :leads, :listing_state, :string
    remove_column :leads, :listing_zip, :string
    remove_column :leads, :original_list_date_at, :datetime
    remove_column :leads, :original_list_price, :decimal
    remove_column :leads, :listing_expires_at, :datetime
    remove_column :leads, :offer_accepted_at, :datetime
    remove_column :leads, :contingencies, :string
    remove_column :leads, :buyer, :string
    remove_column :leads, :buyer_agent, :string
    remove_column :leads, :scheduled_closing_date_at, :datetime
    remove_column :leads, :estimated_gross_commission, :decimal
    remove_column :leads, :deal_value, :decimal
    remove_column :leads, :buyer_address, :string
    remove_column :leads, :buyer_city, :string
    remove_column :leads, :buyer_state, :string
    remove_column :leads, :buyer_zip, :string
    remove_column :leads, :listing_agent, :string
    remove_column :leads, :seller, :string
    remove_column :leads, :buyer_mls, :string
    remove_column :leads, :accepted_contract_price, :decimal
    remove_column :leads, :contract_commission_rate, :decimal
    remove_column :leads, :incoming_lead_address, :string
    remove_column :leads, :incoming_lead_city, :string
    remove_column :leads, :incoming_lead_state, :string
    remove_column :leads, :incoming_lead_zip, :string
    remove_column :leads, :incoming_lead_mls, :string
    remove_column :leads, :incoming_lead_url, :string
    remove_column :leads, :incoming_lead_message, :text
  end

end