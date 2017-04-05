class AddTeamGroupIdToUsers < ActiveRecord::Migration

  def change
    add_column :users, :team_group_id, :integer
    add_index :users, :team_group_id
  end

end
