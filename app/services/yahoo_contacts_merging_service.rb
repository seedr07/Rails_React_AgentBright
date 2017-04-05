class YahooContactsMergingService

  def merge_and_save_contacts(user_id, contacts)
    if contacts.length > 0
      contacts.each do |contact|
        if contact_is_unique?(contact, user_id)
          if save_contact(contact, user_id)
            true
          else
            false
          end
        end
      end
    end
  end

  def contact_is_unique?(contact, user_id)
    user = User.find(user_id)
    contacts = user.contacts
    match_id = contact[:id]
    contacts.where(yahoo_contact_id: match_id).length < 1
  end

  def save_contact(contact, user_id)
    new_contact = Contact.new
    new_contact.user_id = user_id
    new_contact.created_by_user = User.find(user_id)

    new_contact.yahoo_contact_id = contact[:id]

    if contact[:first_name]
      new_contact.first_name = contact[:first_name]
    end

    if contact[:last_name]
      new_contact.last_name = contact[:last_name]
    end

    if contact[:name]
      new_contact.name = contact[:name]
    end

    if contact[:email]
      email = new_contact.email_addresses.new
      email.email = contact[:email]
      email.email_type = "primary"
      email.primary = true
      email.save
    end

    if contact[:address_1]
      address = new_contact.addresses.new
      address.owner_id = new_contact.id
      address.owner_type = "contact"
      address.street = contact[:address_1]
      address.city = contact[:city]
      address.state = contact[:region]
      address.zip = contact[:postcode]
      address.county = "USA"
      address.save
    end

    if contact[:birthday]
      birthday = contact[:birthday]
      new_contact.birthday = "#{birthday[:day]}/#{birthday[:month]}/#{birthday[:year]}"
    end

    begin
      new_contact.save
    rescue Error => e
      error_message = FailedApiImport.new
      error_message.user_id = user_id
      error_message.message = "Failed to Import Yahoo Contact
                              with yahoo contact id : #{contact[:id]}
                              for user with id : #{user_id} at Time.zone.now
                              and the error messge is => #{e.inspect} ...
                              Import Data -> #{contact}"[0, 250]
      error_message.save
    end
  end
end
