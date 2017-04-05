class AddTotalWeeklyEffortToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :total_weekly_effort, :decimal
  end
end
