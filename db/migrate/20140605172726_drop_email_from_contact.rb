class DropEmailFromContact < ActiveRecord::Migration
  def change
    Contact.all.each do |contact|
      contact.email_addresses.build email: contact.email,
                                    email_type: 'Personal',
                                    primary: true if contact.email.present?
      Util.log "Contact =>  #{contact.inspect}"
      Util.log "Email Address =>  #{contact.email_addresses.inspect}"
      contact.save
    end
    remove_column :contacts, :email
  end
end
