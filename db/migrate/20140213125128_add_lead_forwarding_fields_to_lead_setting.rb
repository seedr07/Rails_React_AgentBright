class AddLeadForwardingFieldsToLeadSetting < ActiveRecord::Migration
  def change
    add_column :lead_settings, :forward_lead_to_group, :boolean, default: false
    add_column :lead_settings, :forward_after_minutes, :integer
  end
end
