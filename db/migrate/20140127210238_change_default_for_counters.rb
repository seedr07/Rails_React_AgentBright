class ChangeDefaultForCounters < ActiveRecord::Migration
  def change
  	change_column :users, :wkly_notes_counter, :integer, default: 0
  	change_column :users, :wkly_calls_counter, :integer, default: 0
  	change_column :users, :wkly_visits_counter, :integer, default: 0
  end
end
