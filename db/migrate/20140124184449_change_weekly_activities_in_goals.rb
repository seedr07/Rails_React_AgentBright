class ChangeWeeklyActivitiesInGoals < ActiveRecord::Migration
  def change
  	remove_column :goals, :visits_required_wkly, :string
  	add_column :goals, :visits_required_wkly, :decimal
  end
end
