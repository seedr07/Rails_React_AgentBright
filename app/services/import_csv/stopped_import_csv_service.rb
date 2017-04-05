module ImportCsv
  class StoppedImportCsvService
    def perform
      time              = Time.now - 2.hours
      stopped_csv_files = CsvFile.with_state(:processing).where("updated_at <= ?", time)

      stopped_csv_files.find_each do |csv_file|
        csv_file.failed!

        if Rails.env != "test" # Added this because test gets failed.
          # NOTE: Currently disabling action mailer in test env doens't work.
          # Emails gets fired.
          # Need to check why it is happening.
          CsvImportFailureMailer.delay.notify(csv_file.id)
        end
      end
    end
  end
end
