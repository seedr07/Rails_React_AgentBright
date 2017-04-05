class ChangeTeamToTeamGroupInPlans < ActiveRecord::Migration

  def change
    rename_column :plans, :includes_team, :includes_team_group
  end

end
