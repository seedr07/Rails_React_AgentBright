class AddLeadSourceStatusToLeadSettings < ActiveRecord::Migration
  def change
    add_column :lead_settings, :parse_trulia_leads, :boolean, default: true
    add_column :lead_settings, :parse_realtor_leads, :boolean, default: true
    add_column :lead_settings, :parse_zillow_leads, :boolean, default: true
  end
end
