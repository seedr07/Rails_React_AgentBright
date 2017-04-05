class AddNextActionToTasks < ActiveRecord::Migration

  def change
    add_column(:tasks, :is_next_action, :boolean, default: false, null: false)
  end

end
