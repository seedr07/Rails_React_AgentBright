module ImportCsv
  module Contacts
    class BuildContactWithAssociationsService
      CONTACT_MAPPINGS = {
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

      ADDRESS_MAPPINGS = {
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

      attr_reader :csv_row

      def initialize(csv_row)
        @csv_row = csv_row
      end

      def perform
        build_contact_and_accociations
      end

      private

      def build_contact_and_accociations
        contact = build_object(Contact.new, CONTACT_MAPPINGS)

        address = build_object(Address.new, ADDRESS_MAPPINGS)
        contact.addresses << address if address

        email_addresses = build_email_addresses
        contact.email_addresses << email_addresses if email_addresses.present?

        phone_numbers = build_phone_numbers
        contact.phone_numbers << phone_numbers if phone_numbers.present?

        contact
      end

      def build_object(object, mappings)
        mappings.each do |mapping_title, mapping_attr|
          if object.respond_to?(mapping_attr)
            object.public_send("#{mapping_attr}=", csv_row[mapping_title]) if object.public_send(mapping_attr).blank?
          else
            if csv_row[mapping_title].present?
              object.data[mapping_attr] = csv_row[mapping_title]
              object.data_will_change! # notify Rails, otherwise it won't be saved.
            end
          end
        end

        object
      end

      def build_email_addresses
        email_addresses = []

        EMAIL_ADDRESS_FIELDS.each do |field|
          value = csv_row[field]
          if value.present?
            primary_field = primary_email_field?(field)
            email_addresses << EmailAddress.new(email: value, primary: primary_field)
          end
        end

        email_addresses
      end

      def build_phone_numbers
        phone_numbers = []

        PHONE_TYPE_MAPPINGS.each do |mapping_title, _|
          value = csv_row[mapping_title]
          if value.present?
            phone_type = fetch_phone_type(mapping_title)
            phone_numbers << PhoneNumber.new(number: value, number_type: phone_type)
          end
        end

        phone_numbers
      end

      def primary_email_field?(field)
        ["E-mail Address", "Email", "E-mail"].include? field
      end

      def fetch_phone_type(field)
        PHONE_TYPE_MAPPINGS[field]
      end
    end
  end
end
