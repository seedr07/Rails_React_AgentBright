class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|

      t.references :user
      
      t.string :real_estate_experience
      t.string :contacts_database_storage

      t.string :company
      t.string :personal_website
      t.string :mobile_number
      t.string :office_number
      t.string :fax_number
      
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.string :timezone

      t.string :photo

      t.boolean :subscribed, default: false

      t.timestamps
    end
  end
end
