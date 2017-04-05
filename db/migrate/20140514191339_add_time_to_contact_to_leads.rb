class AddTimeToContactToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :time_before_attempted_contact, :decimal

    Lead.reset_column_information

    Lead.find_each do |lead|
      if lead.attempted_contact_at && lead.incoming_lead_at
        lead.time_before_attempted_contact = lead.attempted_contact_at - lead.incoming_lead_at
        lead.save
      end
    end
  end
end
