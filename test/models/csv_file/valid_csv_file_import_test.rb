require "test_helper"

module RemoteFileURLHelper

  def file_url(url)
    "#{Rails.root}/tmp/#{url}"
  end

end

class CsvFile::ValidCsvFileImportTest < ActiveSupport::TestCase

  include RemoteFileURLHelper
  fixtures :users

  setup do
    @csv_file = CsvFile.create(
      csv: File.open(Rails.root.join("test/fixtures/files/import1.csv")),
      user: users(:nancy)
    )
  end

  test "should change state from uploaded to imported" do
    assert @csv_file.uploaded?
    @csv_file.import! file_url(@csv_file.csv.url)
    assert @csv_file.imported?
  end

  test "should set counters" do
    @csv_file.import! file_url(@csv_file.csv.url)

    assert_equal 2, @csv_file.total_parsed_records
    assert_equal 2, @csv_file.total_imported_records
    assert_equal 0, @csv_file.total_failed_records
  end

  test "should nothing raised" do
    assert_nothing_raised { @csv_file.import! file_url(@csv_file.csv.url) }
  end

  test "should create 2 contacts" do
    assert_difference("Contact.count", 2) do
      @csv_file.import! file_url(@csv_file.csv.url)
    end
  end

  test "should create 2 addresses" do
    assert_difference("Address.count", 2) do
      @csv_file.import! file_url(@csv_file.csv.url)
    end
  end

  test "should map fields" do
    @csv_file.import! file_url(@csv_file.csv.url)
    contact = @csv_file.reload.contacts.first
    address = contact.addresses.first

    # First Name,Last Name,Email,Phone,Company,Address,Address1,City,State,Zip Code
    # Stephanie,Montgomery,montgomery@jourrapide.com,510-339-8384,Wellby,3713 Wayside Lane,,Oakland,CA,94602
    # John,McNulty,nulty@jourrapide.com,812-938-8568,Mulkey,3574,Bernardo Street,Ellettsville,IN,47429

    assert_equal "Stephanie", contact.first_name
    assert_equal "Montgomery", contact.last_name
    assert_equal "montgomery@jourrapide.com", contact.primary_email_address.email
    assert_equal "5103398384", contact.primary_phone_number.number
    assert_equal "Wellby", contact.company
    assert_equal "3713 Wayside Lane", address.address
    assert_equal nil, address.street
    assert_equal "Oakland", address.city
    assert_equal "CA", address.state
    assert_equal "94602", address.zip
  end

  def test_doesnt_import_same_contacts_twice
    skip # As we don't check duplicate records now.

    csv_file2 = @csv_file.dup
    csv_file2.save
    assert_difference("Contact.count", 2) do
      @csv_file.import! file_url(@csv_file.csv.url)
    end
    Rails.logger.info "1. Contact: #{@csv_file.user.contacts.first.inspect}"
    Rails.logger.info "1. Email addresses: #{@csv_file.user.contacts.first.email_addresses.count}"
    assert_difference("Contact.count", 0) do
      csv_file2.import! file_url(csv_file2.csv.url)
    end
    Rails.logger.info "2. Contact: #{@csv_file.user.contacts.first.inspect}"
    Rails.logger.info "2. Email addresses: #{@csv_file.user.contacts.first.email_addresses.count}"
  end

  def test_import_same_contacts_from_different_users
    csv_file2 = @csv_file.dup
    csv_file2.user = users(:john)
    csv_file2.save

    assert_difference("Contact.count", 2) do
      @csv_file.import! file_url(@csv_file.csv.url)
    end
    assert_difference("Contact.count", 2) do
      csv_file2.import! file_url(csv_file2.csv.url)
    end
  end

end
