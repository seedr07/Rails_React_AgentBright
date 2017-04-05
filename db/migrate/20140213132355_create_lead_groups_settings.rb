class CreateLeadGroupsSettings < ActiveRecord::Migration
  def change
    create_table :lead_groups_settings do |t|
      t.integer :lead_setting_id
      t.integer :lead_group_id
    end
  end
end
