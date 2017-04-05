class AddCompletedByToTasks < ActiveRecord::Migration

  def change
    add_column :tasks, :completed_by_id, :integer
    rename_column :tasks, :due_date, :due_date_at
  end 

end
