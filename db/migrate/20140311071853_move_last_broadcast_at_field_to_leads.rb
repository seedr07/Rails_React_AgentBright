class MoveLastBroadcastAtFieldToLeads < ActiveRecord::Migration
  def change
    remove_column :lead_settings, :last_broadcast_at
    add_column :leads, :last_broadcast_at, :datetime
  end
end
