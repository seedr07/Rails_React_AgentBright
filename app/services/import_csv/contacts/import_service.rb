require "activerecord-import/base"
ActiveRecord::Import.require_adapter("postgresql")

module ImportCsv
  module Contacts
    class ImportService
      BULK_INSERT = true

      attr_accessor :csv_file

      def initialize(csv_file)
        @csv_file = csv_file
      end

      def perform
        Rails.logger.info "[CSV.parsing] Processing new csv file..."
        start_time = Time.now
        begin
          process_csv
          csv_file.finish_import!
        rescue => e # parser error or unexpected error
          Rails.logger.error "[CSV.parsing] CSV Import Error: #{e.inspect}"
          csv_file.save_import_error(e)
          csv_file.failed!
          CsvImportFailureMailer.delay.notify(csv_file.id)
        end
        end_time = Time.now
        total_import_time = total_time(start_time, end_time)
        csv_file.update(total_import_time_in_ms: total_import_time)
      end

      def process_csv
        new_contacts           = []
        failed_rows_data       = []

        total_parsed_records   = 0
        total_imported_records = 0
        total_failed_records   = 0

        file = get_file(csv_file.file_url)

        start_parsing_time = Time.now
        CSV.foreach(file, headers: true, :encoding => "iso-8859-1:utf-8") do |csv_row|
          total_parsed_records += 1
          Rails.logger.info "[CSV.parsing] Current processing row #{total_parsed_records}"

          begin
            new_contact = BuildContactWithAssociationsService.new(csv_row).perform
            set_contact_mandatory_fields(new_contact)

            if BULK_INSERT
              # When we want to do bulk insert without using Rails validation/ballbacks logic
              handle_validations(new_contact)
              set_other_fields(new_contact)
              set_primary_to_email_and_phone(new_contact)
              new_contacts << new_contact
            else
              new_contact.save!
            end

            total_imported_records += 1
            Rails.logger.info "[CSV.parsing] Current processing row got passed for importing #{total_failed_records}"
          rescue => e
            total_failed_records += 1
            Rails.logger.info "[CSV.parsing] Current processing row got failed #{total_failed_records}"
            failed_rows_data << [csv_row, e.message]
          end
        end
        end_parsing_time = Time.now
        total_parsing_time = total_time(start_parsing_time, end_parsing_time)
        Rails.logger.info "[CSV.parsing] TOTAL PARSING TIME: #{total_parsing_time} in miliseconds"

        delete_file(file)

        create_contacts_for(new_contacts) if BULK_INSERT && new_contacts.present?
        store_parsed_imported_failed_data(total_parsed_records, total_imported_records, total_failed_records)
        create_invalid_records_for(csv_file, failed_rows_data)
        update_ungraded_contacts_count_for(csv_file.user)
        log_imported_rows
      end

      private

      def set_contact_mandatory_fields(new_contact)
        new_contact.user = csv_file.user
        new_contact.created_by_user = csv_file.user
        new_contact.import_source = csv_file

        new_contact
      end

      def create_contacts_for(new_contacts)
        Rails.logger.info "New contact #{new_contacts.first.inspect}"
        Contact.import new_contacts, recursive: true
      end

      def create_invalid_records_for(csv_file, failed_rows_data)
        invalid_records = []

        failed_rows_data.each do |data|
          invalid_records << CsvFile::InvalidRecord.new(
            csv_file_id: csv_file.id,
            original_row: data[0].to_csv,
            contact_errors: [data[1]]
          )
        end

        CsvFile::InvalidRecord.import invalid_records
      end

      def store_parsed_imported_failed_data(total_parsed_records, total_imported_records, total_failed_records)
        csv_file.update(total_parsed_records: total_parsed_records,
                        total_imported_records: total_imported_records,
                        total_failed_records: total_failed_records)
      end

      def log_imported_rows
        Rails.logger.info(
          "[CSV.parsing] Records parsed:: parsed: #{csv_file.total_parsed_records}"\
          " : imported: #{csv_file.total_imported_records} : failed: "\
          "#{csv_file.total_failed_records}"
        )
      end

      def get_file(file)
        if Rails.env.test?
          file
        else
          remote_csv_data = open(file).read
          tmp_csv_file = Tempfile.open file.gsub(/[^0-9a-z ]/i, ''), "#{Rails.root}/tmp"
          tmp_csv_file.write remote_csv_data.force_encoding("ISO-8859-1").encode("UTF-8")
          tmp_csv_file.rewind
          tmp_csv_file
        end
      end

      def delete_file(file)
        if !Rails.env.test?
          file.close
          file.unlink
        end
      end

      def total_time(start_time, end_time)
        (end_time - start_time) * 1000
      end

      def handle_validations(new_contact)
        errors = []

        if new_contact.first_name.blank? && new_contact.last_name.blank?
          if new_contact.email_blank? && new_contact.phone_blank?
            errors << "Either first name, last name, email addres or phone number should be present"
          end
        end

        new_contact.email_addresses.each do |email_address|
          if !!!(email_address.email =~ AppConstants::EMAIL_REGEX)
            errors << "#{email_address.email} is not valid email address"
          end
        end

        if errors.present?
          raise errors.join(". ")
        end
      end

      def set_other_fields(new_contact)
        new_contact.set_name if new_contact.name.blank?
        new_contact.set_salutations
        new_contact.set_avatar_background_color
      end

      def set_primary_to_email_and_phone(new_contact)
        if new_contact.email_addresses.select(&:primary).blank?
          email_address = new_contact.email_addresses.first
          email_address.primary = true if email_address
        end

        if new_contact.phone_numbers.select(&:primary).blank?
          phone_number = new_contact.phone_numbers.first
          phone_number.primary = true if phone_number
        end
      end

      def update_ungraded_contacts_count_for(user)
        if user
          user.update!(ungraded_contacts_count: user.contacts.active.ungraded.count)
        end
      end
    end
  end
end
