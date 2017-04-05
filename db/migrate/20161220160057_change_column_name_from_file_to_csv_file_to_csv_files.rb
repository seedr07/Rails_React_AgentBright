class ChangeColumnNameFromFileToCsvFileToCsvFiles < ActiveRecord::Migration[5.0]
  def change
    rename_column :csv_files, :file, :csv
  end
end
