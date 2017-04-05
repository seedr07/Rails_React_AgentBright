class AddLeadBroadcastingFieldsToLeadSetting < ActiveRecord::Migration
  def change
    add_column :lead_settings, :broadcast_lead_to_group, :boolean, default: false
    add_column :lead_settings, :broadcast_after_minutes, :integer, default: 5
  end
end
