class ChangeTeamUserAssociation < ActiveRecord::Migration
  def change
    drop_table :teams_users
    create_table :lead_groups_users do |t|
      t.integer "user_id"
      t.integer "lead_group_id"
    end
  end
end
