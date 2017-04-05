module ImportData
  class TopProducerCsvRow < BaseRow

    MAPPING = {

      "Contact ID" => :contact_id,
      "Contact Type" => :contact_type,
      "Source" => :source,
      "Inquiry form" => :inquiry_form,

      "Primary FirstName" => :first_name,
      "Primary LastName" => :last_name,

      [ "Primary FirstName",
        "Primary LastName" ] => :name,

      # Primary Initial - 587
      # Primary NickName - 3
      # Primary Jr_Sr - 3
      # Primary Mr_Mrs - 106
      # Primary Title - 28

      "Letter Salutation" => :letter_salutation,
      "Envelope/Label Salutation" => :envelope_salutation,
      "Company" => :company,

      # Primary Gender - 4
      # Primary Birthday - 23
      # Urgency - 3
      "Contact Note Date" => :note_date,
      "Contact Notes" => :note,

      "Email Address" => :email,
      "Web Address" => :web_address,

      [ "Other Email_Web Type",
        "Other Email_Web Addr",
        "Other Email_Web Desc" ] => :other_email_web_desc,

      "Unsubscribed" => :unsubscribed,
    }

    PHONES_MAPPING = {
      [ "Home Phone",
        "Home Phone Ext",
        "Home Ph Desc" ] => :home_phone,

      [ "Bus Phone",
        "Bus Phone Ext",
        "Bus Ph Desc" ] => :bus_phone,

      [ "Other Phone",
        "Other Ph Desc",
        "Other Ph Nums Title",
        "Other Phone Nums",
        "Other Phone Nums Ext",
        "Other Ph Nums Desc" ] => :other_phone,

      "Mobile Phone" => :mobile_phone,
      # Pager Desc - 4

      [ "Fax Number",
        "Fax Desc" ] => :fax,
    }

    ADDRESS_MAPPING = {
      "Address ID" => :address_id,
      "Property Type" => :property_type,

      [ "House Number",
        "Direction Prefix" ] => :address,

      [ "Street",
        "Street Designator",
        "Direction Suffix",
        "Suite No",
        "PO_Box",
        "Bldg_Floor"] => :street,

      "City" => :city,
      "County" => :county,
      "State" => :state,
      "Zip" => :zip,
      "Country" => :country
    }


    def to_contact
      contact =Contact.new.tap do |contact|
        initiate_instance(contact, MAPPING)
        initiate_instance(contact, PHONES_MAPPING)

        if mapping_has_values?(ADDRESS_MAPPING)
          address = contact.addresses.build
          initiate_instance(address, ADDRESS_MAPPING)
          initiate_instance(address, PHONES_MAPPING)
        end
      end
      [contact, nil]
    end
  end
end
