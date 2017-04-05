class ChangeIncomingLeadMessageInLeads < ActiveRecord::Migration
  def change
    change_column :leads, :incoming_lead_message, :text
  end
end
