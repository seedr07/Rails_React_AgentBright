require "activerecord-import/base"
ActiveRecord::Import.require_adapter("postgresql")

class CsvParsingService
  attr_accessor :csv_file, :contact

  def initialize(csv_file)
    @csv_file = csv_file
    @contact = nil
  end

  def perform
    Rails.logger.info "[CSV.parsing] Processing new csv file..."
    begin
      process_csv
      csv_file.finish_import!
    rescue => e # parser error or unexpected error
      Rails.logger.error "[CSV.parsing] CSV Import Error: #{e.inspect}"
      csv_file.save_import_error(e)
      csv_file.failed!
      CsvImportFailureMailer.delay.notify(csv_file.id)
    end
  end

  def process_csv
    parser = ::ImportData::SmartCsvParser.new(csv_file.file_url)

    total_parsed_records   = 0
    total_imported_records = 0
    total_failed_records   = 0
    failed_rows_data = []

    parser.each do |smart_row|
      total_parsed_records += 1
      Rails.logger.info "[CSV.parsing] Parsing row #{csv_file.total_parsed_records}..."

      begin
       record_imported = process_row(smart_row)
        if record_imported
          total_imported_records += 1
        else
          failed_rows_data << smart_row
          total_failed_records += 1
        end
      rescue => e
        row_parse_error(smart_row, e)
        total_failed_records += 1
      end
    end

    csv_file.update(total_parsed_records: total_parsed_records,
                    total_imported_records: total_imported_records,
                    total_failed_records: total_failed_records)

    log_imported_rows(csv_file)
    create_invalid_records_for(csv_file, failed_rows_data)
  end

  private

  def process_row(smart_row)
    Rails.logger.info "[CSV.parsing] Processing row..."
    new_contact, existing_records = smart_row.to_contact
    Rails.logger.info "[CSV.parsing] new_contact: #{new_contact}"
    Rails.logger.info "[CSV.parsing] new_contact emails: #{new_contact.email_addresses.inspect}"
    Rails.logger.info "[CSV.parsing] exisiting_records: #{existing_records}"
    self.contact = ContactMergingService.new(csv_file.user, new_contact).perform
    init_contact_info self.contact

    record_imported = false

    if contact_valid?
      save_imported_contact(new_contact)
      log_processed_contacts(new_contact)
      record_imported = true
    else
      Rails.logger.info "[CSV.parsing] Contact rejected. Missing name, email or phone number."
      log_processed_contacts(new_contact)
      record_imported = false
    end

    record_imported
  end

  def contact_valid?
    self.contact.first_name || self.contact.last_name ||
      self.contact.email_addresses.first || self.contact.phone_numbers.first
  end

  def save_imported_contact(new_contact)
    Rails.logger.info "[CSV.parsing] Saving new contact..."
    self.contact.save!
    Rails.logger.info "[CSV.parsing] Contact saved. Contact ID: #{self.contact.id}"
  end

  def row_parse_error(smart_row, e)
    Rails.logger.error "[CSV.parsing] Row parse error: #{e.inspect}"
    csv_file.invalid_records.create!(
      original_row: smart_row.row.to_csv,
      contact_errors: contact.try(:errors).try(:full_messages) || [e.inspect]
    )
  end

  def init_contact_info(contact)
    unless contact.persisted?
      contact.user = csv_file.user
      contact.created_by_user = csv_file.user
      contact.import_source = csv_file
    end
    contact.required_salutations_to_set = true # will be used for envelope/letter saluation
  end

  def log_processed_contacts(new_contact)
    Rails.logger.info(
      "[CSV.parsing] Contact- New : #{new_contact.email_addresses.map(&:email)}"\
        " : #{new_contact.first_name} : #{new_contact.last_name} "\
        "#{new_contact.phone_numbers.map(&:number)} :: Old : "\
        "#{self.contact.email_addresses.pluck(:email)} :"\
        "#{self.contact.phone_numbers.pluck(:number)}\n"
    )
  end

  def log_imported_rows(csv_file)
    Rails.logger.info(
      "[CSV.parsing] Records parsed:: parsed: #{csv_file.total_parsed_records}"\
      " : imported: #{csv_file.total_imported_records} : failed: "\
      "#{csv_file.total_failed_records}"
    )
  end

  def create_invalid_records_for(csv_file, failed_rows_data)
    invalid_records = []

    failed_rows_data.each do |failed_row|
      invalid_records << CsvFile::InvalidRecord.new(
        csv_file_id: csv_file.id,
        original_row: failed_row.row.to_csv,
        contact_errors: ["Contact rejected. Missing name, email or phone number"]
      )
    end

    CsvFile::InvalidRecord.import invalid_records
  end
end
