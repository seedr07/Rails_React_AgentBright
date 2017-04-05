class ChangeStageLostTypeToInteger < ActiveRecord::Migration
  def change
    remove_column :leads, :stage_lost
    add_column :leads, :stage_lost, :integer
  end
end
