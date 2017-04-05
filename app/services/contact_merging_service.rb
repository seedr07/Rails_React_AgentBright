class ContactMergingService

  attr_reader :new_contact, :user

  def initialize(user, new_contact)
    @user          = user
    @new_contact   = new_contact
    @found_records = matching_emails_and_phone_numbers
  end

  def perform
    Rails.logger.info "[CSV.merging] Checking if new contact matches existing contact..."
    if existing_contact
      Rails.logger.info "[CSV.merging] Contact match found."
      merge(existing_contact, new_contact)
      existing_contact
    else
      Rails.logger.info "[CSV.merging] No contact match found."
      new_contact
    end
  end

  private

  def existing_contact
    Rails.logger.info "[CSV.merging] Found records: #{@found_records.inspect}"
    @_existing_contact ||= if @found_records.present?
                             # Fetch first owner
                             @user.contacts.find @found_records.first.owner_id
                           end
  end

  def merge(existing_contact, new_contact)
    Rails.logger.info "[CSV.merging] Merging with existing contact (ID: #{existing_contact.id})..."
    merge_records(existing_contact, new_contact)
  end

  def merge_records(existing_contact, new_contact)
    merge_contact(existing_contact, new_contact)
    merge_emails(existing_contact, new_contact)
    merge_phone_numbers(existing_contact, new_contact)
  end

  def merge_contact(existing_contact, new_contact)
    existing_contact.attributes do |field, value|
      if value.blank? && new_contact[field].present?
        existing_contact[field] = new_contact[field]
      end
    end
  end

  def merge_emails(existing_contact, new_contact)
    new_contact.email_addresses.each do |email_address|
      Rails.logger.info "[CSV.merging.emails] Email: #{email_address.inspect}"
      if existing_contact.email_addresses.find_by(email: email_address.email)
        Rails.logger.info "[CSV.merging.emails] Email address exists."
      else
        Rails.logger.info "[CSV.merging.emails] Email does not already exist. Saving..."
        email_address.owner = existing_contact
        email_address.save!
      end
    end
  end

  def merge_phone_numbers(existing_contact, new_contact)
    new_contact.phone_numbers.each do |phone_number|
      Rails.logger.info "[CSV.merging.phone] Phone Number: #{phone_number.inspect}"
      if existing_contact.phone_numbers.find_by(number: phone_number.number)
        Rails.logger.info "[CSV.merging.phone] Phone number exists."
      else
        Rails.logger.info "[CSV.merging.phone] Phone Number does not already exist. Saving..."
        phone_number.owner = existing_contact
        phone_number.save!
      end
    end
  end

  def matching_emails_and_phone_numbers
    records = []

    if @user
      records << matching_emails
      records << matching_phone_numbers
      records.flatten!
      records.compact!

      Rails.logger.info "[CSV.merging] merged records: #{records.inspect}"
    end

    records
  end

  def matching_emails
    existing_emails = []
    new_contact_emails = @new_contact.email_addresses

    new_contact_emails.each do |email|
      Rails.logger.info "[CSV.merging] Checking for a match on email: #{email.inspect}..."
      if existing_email = @user.contact_email_addresses.find_by(email: email.email, primary: email.primary)
        Rails.logger.info "[CSV.merging] Found a matching email"
        existing_emails << existing_email
      else
        Rails.logger.info "[CSV.merging] No match found"
      end
    end

    existing_emails
  end

  def matching_phone_numbers
    existing_phone_numbers = []
    new_contact_phone_numbers = @new_contact.phone_numbers

    new_contact_phone_numbers.each do |phone_number|
      Rails.logger.info "[CSV.merging] Checking for a match on phone_number: #{phone_number.inspect}..."
      if existing_phone_number = @user.contact_phone_numbers.find_by(number: phone_number.number)
        Rails.logger.info "[CSV.merging] Found a matching phone number"
        existing_phone_numbers << existing_phone_number
      else
        Rails.logger.info "[CSV.merging] No match found"
      end
    end

    existing_phone_numbers
  end

  def clean_phone_number(number)
    number.gsub(/[\s\-\(\)]+/, "")
  end

end
