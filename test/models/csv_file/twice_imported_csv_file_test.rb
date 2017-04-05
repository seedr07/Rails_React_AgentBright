require "test_helper"

module RemoteFileURLHelper

  def file_url(url)
    "#{Rails.root}/tmp/#{url}"
  end

end

class CsvFile::TwiceImportCsvFileTest < ActiveSupport::TestCase

  include RemoteFileURLHelper
  fixtures :users

  setup do
    @csv_file = CsvFile.create(
      csv: File.open(Rails.root.join("test/fixtures/files/import1.csv")),
      user: users(:nancy)
    )
  end

  test "raise of TwiceImportError" do
    @csv_file.import! file_url(@csv_file.csv.url)

    assert_raise(CsvFile::TwiceImportError) do
      @csv_file.import! file_url(@csv_file.csv.url)
    end
  end

end
