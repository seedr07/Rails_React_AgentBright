class AddTotalImportTimeToCsvFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :csv_files, :total_import_time_in_ms, :string
  end
end
