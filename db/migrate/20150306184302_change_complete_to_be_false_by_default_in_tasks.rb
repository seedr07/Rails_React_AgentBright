class ChangeCompleteToBeFalseByDefaultInTasks < ActiveRecord::Migration

  def change
    change_column :tasks, :completed, :boolean, default: false, null: false
  end

end
