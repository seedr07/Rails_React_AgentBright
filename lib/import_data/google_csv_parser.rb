require 'import_data/base_parser'
require 'import_data/google_csv_row'

module ImportData
  class GoogleCsvParser < BaseParser

    def row_class
      ::ImportData::GoogleCsvRow
    end

    def initialize(path='./tmp/google.csv')
      super
    end

    # p.appearance("Home Address").size       # => 1569
    # p.appearance("Business Address").size   # => 22
    # p.appearance("Other Address").size      # => 1344

    # p.appearance("Home Address", "Business Address").size   # => 12
    # p.appearance("Home Address", "Other Address").size      # => 1171
    # p.appearance("Business Address", "Other Address").size  # => 2

    # p.appearance("Home Address", "Business Address", "Other Address").size      # => 1
    # p.appearance("Home Address", "Business Address", "Other Address", n:2).size # => 1182
    # p.appearance("Home Address", "Business Address", "Other Address", n:1).size # => 568

    def each_contact
      each {|row| yield row.to_contact[0] }
    end

    # First Name
    # Middle Name
    # Last Name
    # Title
    # Suffix
    # Initials
    # Web Page
    # Gender
    # Birthday
    # Anniversary
    # Location
    # Language
    # Internet Free Busy
    # Notes
    # E-mail Address
    # E-mail 2 Address
    # E-mail 3 Address
    # Primary Phone
    # Home Phone
    # Home Phone 2
    # Mobile Phone
    # Pager
    # Home Fax
    # Home Address
    # Home Street
    # Home Street 2
    # Home Street 3
    # Home Address PO Box
    # Home City
    # Home State
    # Home Postal Code
    # Home Country
    # Spouse
    # Children
    # Manager's Name
    # Assistant's Name
    # Referred By
    # Company Main Phone
    # Business Phone
    # Business Phone 2
    # Business Fax
    # Assistant's Phone
    # Company
    # Job Title
    # Department
    # Office Location
    # Organizational ID Number
    # Profession
    # Account
    # Business Address
    # Business Street
    # Business Street 2
    # Business Street 3
    # Business Address PO Box
    # Business City
    # Business State
    # Business Postal Code
    # Business Country
    # Other Phone
    # Other Fax
    # Other Address
    # Other Street
    # Other Street 2
    # Other Street 3
    # Other Address PO Box
    # Other City
    # Other State
    # Other Postal Code
    # Other Country
    # Callback
    # Car Phone
    # ISDN
    # Radio Phone
    # TTY/TDD Phone
    # Telex
    # User 1
    # User 2
    # User 3
    # User 4
    # Keywords
    # Mileage
    # Hobby
    # Billing Information
    # Directory Server
    # Sensitivity
    # Priority
    # Private
    # Categories
  end
end