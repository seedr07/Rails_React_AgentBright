require "test_helper"

module RemoteFileURLHelper

  def file_url(url)
    "#{Rails.root}/tmp/#{url}"
  end

end

class CsvFile::InvalidCsvFileImportTest < ActiveSupport::TestCase

  include RemoteFileURLHelper
  fixtures :users

  setup do
    @csv_file = CsvFile.new(csv: File.open(Rails.root.join("test/fixtures/files/import1.csv")))
    # make contacts invalid through user
    # when validations added to contacts use invalid fields instead
    @csv_file.user = nil
    @csv_file.save
  end

  test "should change state from uploaded to imported" do
    assert @csv_file.uploaded?
    @csv_file.import! file_url(@csv_file.csv.url)
    assert @csv_file.imported?
  end

  test "should set counters" do
    skip # due to new import service changes
    @csv_file.import! file_url(@csv_file.csv.url)

    assert_equal 2, @csv_file.total_parsed_records
    assert_equal 0, @csv_file.total_imported_records
    assert_equal 2, @csv_file.total_failed_records
  end

  test "should nothing raised" do
    assert_nothing_raised { @csv_file.import! file_url(@csv_file.csv.url) }
  end

  test "should not create contacts" do
    assert_no_difference("Contact.count") do
      @csv_file.import! file_url(@csv_file.csv.url)
    end
  end

  test "should not create addresses" do
    skip # due to new import service changes

    assert_no_difference("Address.count") do
      @csv_file.import! file_url(@csv_file.csv.url)
    end
  end

  test "should create 2 invalid records" do
    skip # due to new import service changes

    assert_difference("::CsvFile::InvalidRecord.count", 2) do
      @csv_file.import! file_url(@csv_file.csv.url)
    end
  end

  test "should store invalid row and errors" do
    skip # due to new import service changes

    @csv_file.import! file_url(@csv_file.csv.url)
    invalid_record = @csv_file.invalid_records.first

    assert_equal(
      "Stephanie,Montgomery,montgomery@jourrapide.com,510-339-8384,Wellby,"\
        "3713 Wayside Lane,,Oakland,CA,94602\n",
      invalid_record.original_row
    )
    assert_equal(
      ["Validation failed: Created by user Please enter a value"],
      invalid_record.contact_errors
    )
  end

end
