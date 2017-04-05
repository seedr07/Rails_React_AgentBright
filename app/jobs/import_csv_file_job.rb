class ImportCsvFileJob < ActiveJob::Base

  queue_as :default

  def perform(csv_file_id)
    csv_file = CsvFile.find(csv_file_id)

    csv_file.import!
    csv_file.send_report!
  end

end
