require "test_helper"

class ImportCsv::StoppedImportCsvServiceTest < ActiveSupport::TestCase
  def test_perform
    john = users(:john)
    csv_file = CsvFile.create!(csv: mock, user_id: john.id)
    csv_file.state = "processing"
    csv_file.updated_at = Time.now - 2.hours
    csv_file.save!

    ImportCsv::StoppedImportCsvService.new.perform
    csv_file.reload

    assert_equal "failed", csv_file.state
  end
end
