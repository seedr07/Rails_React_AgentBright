class AddReceiveDailyClientActivityRecapToLeadSettings < ActiveRecord::Migration
  def change
    add_column :lead_settings, :receive_daily_client_activity_recap, :boolean
  end
end
