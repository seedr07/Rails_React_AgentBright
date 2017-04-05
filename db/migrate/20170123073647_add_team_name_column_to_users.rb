class AddTeamNameColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :team_name, :string
  end
end
