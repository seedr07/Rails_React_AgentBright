class DropContactAddressFields < ActiveRecord::Migration
  def change

    Contact.find_each do |contact|
      unless contact.addresses.present?
        contact.addresses << Address.create!(address: contact.address1, street: contact.address2, city: contact.city, state: contact.state, zip: contact.zip)
      end
      Util.log "Contact #{contact.inspect}"
      Util.log "Address #{contact.addresses.inspect}"
      contact.save
    end

    remove_column :contacts, :state
    remove_column :contacts, :city
    remove_column :contacts, :zip
    remove_column :contacts, :address1
    remove_column :contacts, :address2
  end
end