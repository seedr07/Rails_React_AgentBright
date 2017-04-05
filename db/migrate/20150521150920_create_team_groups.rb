class CreateTeamGroups < ActiveRecord::Migration

  def change
    create_table :team_groups do |t|
      t.references :subscription, index: true, foreign_key: true, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end

end
