class ConvertErrorsHstoreIntoContactsErrorsSerializerForCsvFileInvalidRecords < ActiveRecord::Migration
  def change
    remove_column :csv_file_invalid_records, :errors
    add_column :csv_file_invalid_records, :contact_errors, :text
  end
end
