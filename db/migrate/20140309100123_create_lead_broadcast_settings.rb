class CreateLeadBroadcastSettings < ActiveRecord::Migration
  def change
    create_table :lead_group_broadcast_settings do |t|
      t.integer :lead_setting_id
      t.integer :lead_group_id
    end
  end

end
