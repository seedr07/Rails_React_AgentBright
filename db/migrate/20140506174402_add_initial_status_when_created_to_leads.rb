class AddInitialStatusWhenCreatedToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :initial_status_when_created, :integer
  end
end
