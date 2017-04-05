require "test_helper"

class ImportCsvFileJobTest < ActiveJob::TestCase

  def test_perform_import_csv
    csv_file_id = 1
    csv_file = mock
    CsvFile.expects(:find).with(csv_file_id).returns(csv_file)
    csv_file.expects(:import!).returns(true)
    csv_file.expects(:send_report!).returns(true)
    assert_equal(
      true,
      ImportCsvFileJob.perform_now(csv_file_id)
    )
  end

end
