class GoogleContactsMergingService

  def merge_and_save_contacts(user_id, contacts)
    if contacts.length > 0
      contacts.each do |contact|
        if contact_is_unique?(contact, user_id)
          Util.log "SAVING GOOGLE API CONTACT -> #{contact}"
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
    contacts.where(google_api_contact_id: match_id).length < 1
  end

  def save_contact(contact, user_id)
    new_contact = Contact.new
    new_contact.user_id = user_id
    new_contact.created_by_user = User.find(user_id)

    new_contact.google_api_contact_id = contact[:id]

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

    if contact[:emails] && contact[:emails].length > 0
      contact[:emails].each do |email|
        new_email = new_contact.email_addresses.new
        new_email.email_type = email[:name]
        new_email.email = email[:email]
        new_email.primary = false
        new_email.save
      end
    end

    if contact[:phone_number]
      number = new_contact.phone_numbers.new
      number.owner_id = new_contact.id
      number.owner_type = "contact"
      number.number = contact[:phone_number]
      number.number_type = "primary"
      number.primary = true
      number.save
    end

    if contact[:phone_numbers] && contact[:phone_numbers].length > 0
      contact[:phone_numbers].each do |phone_number|
        number = new_contact.phone_numbers.new
        number.owner_id = new_contact.id
        number.owner_type = "contact"
        number.number = phone_number[:number]
        number.number_type = phone_number[:name]
        number.primary = false
        number.save
      end
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

    if contact[:addresses] && contact[:addresses].length > 0
      contact[:addresses].each do |address|
        new_address = new_contact.addresses.new
        new_address.owner_id = new_contact.id
        new_address.owner_type = "contact"
        new_address.street = address[:address_1]
        new_address.city = address[:city]
        new_address.state = address[:region]
        new_address.zip = address[:postcode]
        new_address.county = "USA"
        new_address.save
      end
    end

    if contact[:company]
      new_contact.company = contact[:company]
    end

    if contact[:position]
      new_contact.profession = contact[:position]
    end

    if contact[:birthday]
      new_contact.birthday = contact[:birthday]
    end

    new_contact.save
  end

end
