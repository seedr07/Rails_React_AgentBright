class AddJunkReasonToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :junk_reason, :text
  end
end
