class AddCountersToCsvFiles < ActiveRecord::Migration
  def change
    add_column :csv_files, :total_parsed_records,   :integer, default: 0
    add_column :csv_files, :total_imported_records, :integer, default: 0
    add_column :csv_files, :total_failed_records,   :integer, default: 0
  end
end
