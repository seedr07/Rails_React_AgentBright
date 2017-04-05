class AddLastBroadcastAtToLeadSetting < ActiveRecord::Migration
  def change
    add_column :lead_settings, :last_broadcast_at, :datetime
  end
end
