class AddNextActionToLead < ActiveRecord::Migration

  def change
    add_column :leads, :next_action_id, :integer
  end

end
