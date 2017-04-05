class AddAwayStatusSettingsToLeadSettings < ActiveRecord::Migration
  def change
    add_column :lead_settings, :away, :boolean, default: false
    add_column :lead_settings, :vacation_end_at, :datetime
    add_column :lead_settings, :quiet_hours, :boolean, default: false
    add_column :lead_settings, :quiet_hours_start, :integer
    add_column :lead_settings, :quiet_hours_end, :integer
    add_column :lead_settings, :receive_sms_on_weekends, :boolean, default: true
  end
end
