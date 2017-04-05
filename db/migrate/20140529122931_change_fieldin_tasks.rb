class ChangeFieldinTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :assigned_to, :assigned_to_id
  end
end
