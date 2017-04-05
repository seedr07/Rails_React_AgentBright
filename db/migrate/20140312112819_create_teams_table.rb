class CreateTeamsTable < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :user_id
      t.timestamps
    end

    User.find_in_batches do |users|
      users.each do |user|
        user.team_owned = Team.create!
        user.save
      end
    end

  end
end
