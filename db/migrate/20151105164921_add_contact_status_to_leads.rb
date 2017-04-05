class AddContactStatusToLeads < ActiveRecord::Migration

  def change
    add_column :leads, :contact_status, :integer, default: 0

    puts "TOTAL BEFORE:"
    puts Lead.all.count
    puts "Total not contacted:"
    puts Lead.where(contacted_status: "not_contacted").count
    puts "Total attempted:"
    puts Lead.where(contacted_status: "attempted_contact").count
    puts "Total awaiting:"
    puts Lead.where(contacted_status: "awaiting_client_response").count
    puts "Total contacted:"
    puts Lead.where(contacted_status: "contacted").count
    puts "Total with empty"
    puts Lead.where(contacted_status: "").count
    puts "Total with 0"
    puts Lead.where(contacted_status: "0").count
    puts "Total with 1"
    puts "total contacted with 1:"
    puts Lead.where(contacted_status: "1").count
    puts "Total with 2"
    puts Lead.where(contacted_status: "2").count
    puts "total with 3:"
    puts Lead.where(contacted_status: "3").count

    Lead.reset_column_information

    Lead.all.each do |lead|
      case lead.contacted_status
      when "not_contacted" || "0" || ""
        lead.update_columns(contact_status: 0)
      when "attempted_contact" || "1"
        lead.update_columns(contact_status: 1)
      when "awaiting_client_response" || "2"
        lead.update_columns(contact_status: 2)
      when "contacted" || "3"
        lead.update_columns(contact_status: 3)
      end

      puts "Name: #{lead.name}"
      puts "Contacted Status: #{lead.contacted_status}"
      puts "Contact Status: #{lead.contact_status}"
    end

    remove_column :leads, :contacted_status
    rename_column :leads, :contact_status, :contacted_status
    add_index :leads, :contacted_status

    puts "total AFTER:"
    puts Lead.all.count
    puts "total not contacted"
    puts Lead.where(contacted_status: 0).count
    puts "total attempted: "
    puts Lead.where(contacted_status: 1).count
    puts "total awaiting: "
    puts Lead.where(contacted_status: 2).count
    puts "total contacted:"
    puts Lead.where(contacted_status: 3).count
  end

end
