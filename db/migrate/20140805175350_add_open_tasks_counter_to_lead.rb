class AddOpenTasksCounterToLead < ActiveRecord::Migration

  def change
    add_column :leads, :incomplete_tasks_count, :integer, :default => 0

    Lead.reset_column_information
    Lead.all.each do |lead|
      lead.update_column :incomplete_tasks_count, lead.tasks.not_completed.count
    end
  end

end
