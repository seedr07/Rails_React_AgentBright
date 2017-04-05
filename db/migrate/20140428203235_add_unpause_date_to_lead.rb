class AddUnpauseDateToLead < ActiveRecord::Migration
  def change
    add_column :leads, :unpause_date_at, :datetime
  end
end
