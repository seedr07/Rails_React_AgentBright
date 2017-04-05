class AddDailyCountersToUser < ActiveRecord::Migration
  def change
    add_column :users, :dly_calls_counter, :integer, default: 0
    add_column :users, :dly_notes_counter, :integer, default: 0
    add_column :users, :dly_visits_counter, :integer, default: 0
  end
end
