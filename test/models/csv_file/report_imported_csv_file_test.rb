require "test_helper"

module RemoteFileURLHelper

  def file_url(url)
    "#{Rails.root}/tmp/#{url}"
  end

end

class CsvFile::ReportImportCsvFileTest < ActiveSupport::TestCase

  include RemoteFileURLHelper
  fixtures :users

  setup do
    @csv_file = CsvFile.create(
      csv: File.open(Rails.root.join("test/fixtures/files/import1.csv")),
      user: users(:nancy)
    )
  end

  test "should raise ReportBeforeImportError" do
    assert_raise(CsvFile::ReportBeforeImportError) do
      @csv_file.send_report!
    end
  end

  test "should send report email" do
    @csv_file.import! file_url(@csv_file.csv.url)

    Mailer.expects(:csv_import_report).with(@csv_file).returns(stub(deliver: true))
    @csv_file.send_report!
  end

end
