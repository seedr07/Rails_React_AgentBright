class AddDailyGoalFieldsToGoals < ActiveRecord::Migration
  def change
  	add_column :goals, :daily_calls_goal, :integer, default: 0
  	add_column :goals, :daily_notes_goal, :integer, default: 0
  	add_column :goals, :daily_visits_goal, :integer, default: 0
  end
end
