module ImportData
  class GoogleCsvRow < BaseRow

    MAPPING = {
      "First Name" => :first_name,
      "Last Name"  => :last_name,

      [ "First Name",
        "Middle Name",
        "Last Name" ] => :name,

      # "Title"
      # "Suffix"

      "Birthday" => :birthday,
      "Notes" => :notes,

      "E-mail Address" => :email,
      "E-mail 2 Address" => :email2,
      "E-mail 3 Address" => :email3,
      "Primary Phone" => :primary_phone,
      "Spouse" => :spouse,

      [ "First Name",
        "Last Name"] => :envelope_salutation,

      [ "First Name",
        "Last Name"] => :letter_salutation,

      "Company" => :company,

      # Other Address
      # Other Street
      # Other City
      # Other State
      # Other Postal Code
      # Other Country

      "Priority" => :priority,
      "Categories" => :categories
    }

    def to_contact
      contact = Contact.new.tap do |contact|
        initiate_instance(contact, MAPPING)

        contact.addresses << home_address     if home_address
        contact.addresses << business_address if business_address
        contact.addresses << other_address    if other_address
      end
      [contact, nil]
    end

    BUSINESS_ATTRIBUTES_MAPPING = {
      "Business Address"      => :address,
      "Business Street"       => :street,
      "Business City"         => :city,
      "Business State"        => :state,
      "Business Postal Code"  => :zip,
      "Business Country"      => :county,

      "Company"               => :company,
      "Job Title"             => :job_title,
      "Business Phone"        => :phone,
      "Business Phone 2"      => :phone2,
      "Business Fax"          => :fax
    }

    def business_address
      @business_address ||= initiate_instance(BusinessAddress.new, BUSINESS_ATTRIBUTES_MAPPING)
    end

    HOME_ATTRIBUTES_MAPPING = {
      "Home Address"      => :address,
      "Home Street"       => :street,
      "Home City"         => :city,
      "Home State"        => :state,
      "Home Postal Code"  => :zip,
      "Home Country"      => :county,

      "Mobile Phone"      => :mobile,
      "Home Phone"        => :phone,
      "Home Phone 2"      => :phone2,
      "Home Fax"          => :fax
    }

    def home_address
      @home_address ||= initiate_instance(HomeAddress.new, HOME_ATTRIBUTES_MAPPING)
    end

    OTHER_ATTRIBUTES_MAPPING = {
      "Other Address"      => :address,
      "Other Street"       => :street,
      "Other City"         => :city,
      "Other State"        => :state,
      "Other Postal Code"  => :zip,
      "Other Country"      => :county,

      "Other Phone"        => :phone,
      "Other Fax"          => :fax,
    }

    def other_address
      @other_address ||= initiate_instance(OtherAddress.new, OTHER_ATTRIBUTES_MAPPING)
    end
  end
end