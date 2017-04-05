class AddImportSourceToContacts < ActiveRecord::Migration
  def change
    change_table(:contacts) do |t|
      t.references :import_source, polymorphic: true
    end
  end
end
