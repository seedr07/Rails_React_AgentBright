class ChangeStagePausedTypeToInteger < ActiveRecord::Migration
  def change
    remove_column :leads, :stage_paused
    add_column :leads, :stage_paused, :integer
  end
end
