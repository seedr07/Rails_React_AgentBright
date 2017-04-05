class DropMobilePhoneFromContact < ActiveRecord::Migration
  def change
    Contact.all.each do |contact|
      contact.phone_numbers.build  number: contact.mobile_phone,
                                   number_type: 'Mobile',
                                   primary: true if contact.mobile_phone.present?
      Util.log "Contact =>  #{contact.inspect}"
      Util.log "Phone Number =>  #{contact.phone_numbers.inspect}"
      contact.save
    end
    remove_column :contacts, :mobile_phone
  end
end
