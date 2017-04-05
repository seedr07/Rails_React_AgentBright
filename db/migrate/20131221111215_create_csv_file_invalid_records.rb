class CreateCsvFileInvalidRecords < ActiveRecord::Migration
  def change
    create_table :csv_file_invalid_records do |t|
      t.references :csv_file

      t.text :original_row
      t.hstore :errors

      t.timestamps
    end
  end
end
