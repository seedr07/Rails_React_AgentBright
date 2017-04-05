class AddCounterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wkly_calls_counter, :integer
    add_column :users, :wkly_notes_counter, :integer
    add_column :users, :wkly_visits_counter, :integer
  end
end
