class CreateTeamsUsers < ActiveRecord::Migration
  def change
    create_table :teammates do |t|
      t.integer :user_id
      t.integer :team_id
      t.string :status
      t.timestamps
    end

    add_index :teammates, [:user_id, :team_id], unique: true
  end
end
