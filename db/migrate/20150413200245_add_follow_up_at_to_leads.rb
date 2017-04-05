class AddFollowUpAtToLeads < ActiveRecord::Migration

  def change
    add_column :leads, :follow_up_at, :datetime
    add_column :leads, :last_follow_up_at, :datetime
  end

end
