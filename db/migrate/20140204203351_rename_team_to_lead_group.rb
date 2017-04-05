class RenameTeamToLeadGroup < ActiveRecord::Migration
  def change
    rename_table :teams, :lead_groups
  end
end
