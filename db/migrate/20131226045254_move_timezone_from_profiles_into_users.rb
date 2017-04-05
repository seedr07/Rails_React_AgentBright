class MoveTimezoneFromProfilesIntoUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string
    remove_column :profiles, :timezone, :string
  end
end
