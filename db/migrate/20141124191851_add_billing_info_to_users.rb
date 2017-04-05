class AddBillingInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :billing_first_name, :string, default: ""
    add_column :users, :billing_last_name, :string, default: ""
    add_column :users, :billing_address, :string, default: ""
    add_column :users, :billing_address_2, :string, default: ""
    add_column :users, :billing_email_address, :string, default: ""
    add_column :users, :billing_organization, :string, default: ""
    add_column :users, :billing_state, :string, default: ""
    add_column :users, :billing_city, :string, default: ""
    add_column :users, :billing_zip_code, :string, default: ""
    add_column :users, :billing_country, :string, default: ""
  end
end
