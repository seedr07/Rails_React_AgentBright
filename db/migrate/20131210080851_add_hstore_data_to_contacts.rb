class AddHstoreDataToContacts < ActiveRecord::Migration
  def change
  	enable_extension "hstore"
  	add_column :contacts, :data, :hstore, default: {}
  end
end
