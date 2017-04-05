class AddProfileFieldsToUser < ActiveRecord::Migration
  def change
    drop_table :profiles
    add_column :users, :real_estate_experience, :string
    add_column :users, :contacts_database_storage, :string
    add_column :users, :company, :string
    add_column :users, :personal_website, :string
    add_column :users, :office_number, :string
    add_column :users, :fax_number, :string
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :string
    add_column :users, :country, :string
    add_column :users, :subscribed, :boolean, default: false
    add_column :users, :company_website, :string
  end
end