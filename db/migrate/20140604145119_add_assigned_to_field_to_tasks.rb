class AddAssignedToFieldToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :type_associated, :string
  end
end
