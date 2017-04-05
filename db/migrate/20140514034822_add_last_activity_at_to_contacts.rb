class AddLastActivityAtToContacts < ActiveRecord::Migration
  
  def change
    add_column :contacts, :last_activity_at, :datetime
    add_column :contacts, :next_activity_at, :datetime

    Contact.reset_column_information

    Contact.find_each do |contact|
      if contact.last_activity_at.nil?
        contact.last_activity_at = contact.last_contacted_date
      end

      if contact.next_activity_at.nil?
        contact.next_activity_at = contact.next_contact_date
      end
      contact.save
    end
  end

end
