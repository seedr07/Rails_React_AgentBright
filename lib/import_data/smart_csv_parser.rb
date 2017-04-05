require "fuzzy_match"
require "import_data/base_parser"

module ImportData
  class SmartCsvParser < BaseParser

    def row_class
      ::ImportData::SmartCsvRow
    end

    def each_contact
      each { |row| yield row.to_contact[0] }
    end
  end

  class SmartCsvRow < BaseRow

    CONTACT_MAPPING = {
      "Name" => :name,
      "First Name" => :first_name,
      "Last Name" => :last_name,
      "Middle Name" => "",
      "Spouse" => :spouse,
      "Company" => :company,
      "Profession" => :profession,
      "Grade" => :grade,
      "Mobile Phone" => :mobile_phone,
      "Notes" => :notes,
      "Account" => "",
      "Internet Free Busy" => "",
    }

    ADDRESS_MAPPING = {
      "Address" => :address,
      "Address1" => :street,
      "Street" => :street,
      "City" => :city,
      "State" => :state,
      "Postal Code" => :zip,
      "Zip" => :zip,
      "Zip Code" => :zip,
      "Country" => :country,
      "Home Address" => :address,
      "Home Street" => :street,
      "Home Street 2" => :street,
      "Home Street 3" => :street,
      "Home Address PO Box" => :street,
      "Home City" => :city,
      "Home State" => :state,
      "Home Postal Code" => :zip,
      "Home Country" => :country,
      "Business Address" => :address,
      "Business Street" => :street,
      "Business Street 2" => :street,
      "Business Street 3" => :street,
      "Business Address PO Box" => :street,
      "Business City" => :city,
      "Business State" => :state,
      "Business Postal Code" => :zip,
      "Business Country" => :country,
      "Other Address" => :address,
      "Other Street" => :street,
      "Other Street 2" => :street,
      "Other Street 3" => :street,
      "Other Address PO Box" => :street,
      "Other City" => :city,
      "Other State" => :state,
      "Other Postal Code" => :zip,
      "Other Country" => :country,
    }

    EMAIL_ADDRESS_FIELDS = [
      "Email",
      "E-mail Address",
      "Email 2 Address",
      "Email 3 Address",
      "E-mail",
      "E-mail 2 Address",
      "E-mail 3 Address"
    ]
    PHONE_TYPE_MAPPINGS  = {
      "Phone" => "Home",
      "Primary Phone" => "Home",
      "Home Phone" => "Home",
      "Home Phone 2" => "Home",
      "Mobile Phone" => "Mobile",
      "Home Fax" => "Fax",
      "Business Phone" => "Work",
      "Business Phone 2" => "Work",
      "Business Fax" => "Fax",
      "Other Phone" => "Other",
      "Other Fax" => "Fax",
      "Company Main Phone" => "Work",
    }

    def initialize(headers, row)
      headers = headers.map { |h| best_match_or_self(h) }
      super(headers, row)
    end

    def to_contact
      existing_emails = existing_phone_numbers = nil
      contact = Contact.new.tap do |contact|
        initiate_instance(contact, CONTACT_MAPPING)
        address = initiate_instance(Address.new, ADDRESS_MAPPING)
        contact.addresses << address if address
        email_addresses, existing_emails = initialize_emails(EMAIL_ADDRESS_FIELDS)
        Rails.logger.info "[CSV.smart_parser] initialized email addresses: #{email_addresses}"
        Rails.logger.info "[CSV.smart_parser] contact.email_addresses before: #{contact.email_addresses.inspect}"
        contact.email_addresses << email_addresses
        Rails.logger.info "[CSV.smart_parser] contact.email_addresses after: #{contact.email_addresses.inspect}"
        phone_numbers, existing_phone_numbers = initialize_phone_numbers(PHONE_TYPE_MAPPINGS)
        contact.phone_numbers << phone_numbers
        Rails.logger.info "[CSV.smart_parser] contact.phone_numbers: #{contact.phone_numbers.inspect}"
      end
      existing_records = []
      existing_records << existing_emails
      existing_records << existing_phone_numbers
      existing_records.flatten!
      existing_records.compact!
      [contact, existing_records]
    end

    private

    def fetch_phone_type field
      PHONE_TYPE_MAPPINGS[field]
    end

    FM = FuzzyMatch.new(CONTACT_MAPPING.keys + ADDRESS_MAPPING.keys + EMAIL_ADDRESS_FIELDS + PHONE_TYPE_MAPPINGS.keys)

    def best_match_or_self(header)
      # Select if Dice's Coefficient
      # choose closet by Levenshtein distance
      candidate = FM.find(header, find_all_with_score: true).
                  select { |(_text, dice, _lev)| dice > 0.5 }.
                  max_by { |(_text, _dice, lev)| lev }

      # if cannot find candidate return header
      candidate ? candidate[0] : header
    end

  end

end
