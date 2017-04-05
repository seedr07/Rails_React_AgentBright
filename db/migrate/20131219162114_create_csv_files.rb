class CreateCsvFiles < ActiveRecord::Migration
  def change
    create_table :csv_files do |t|
      t.belongs_to :user
      t.index :user_id

      t.string :file
      t.string :state
      t.hstore :import_result, default: {}

      t.timestamps
    end
  end
end
