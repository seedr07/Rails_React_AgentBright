class AddSuggestedToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :suggested_profile_picture, :string
    add_column :contacts, :suggested_first_name, :string
    add_column :contacts, :suggested_last_name, :string
    add_column :contacts, :suggested_location, :string
    add_column :contacts, :suggested_organization_name, :string
    add_column :contacts, :suggested_job_title, :string
    add_column :contacts, :suggested_linkedin_bio, :string
  end
end
