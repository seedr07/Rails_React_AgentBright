class CreateShowings < ActiveRecord::Migration
  def change
    create_table :showings do |t|
      t.integer :lead_id
      t.integer :status
      t.string :address1
      t.string :city
      t.string :state
      t.string :zip
      t.datetime :date_time
      t.text :comments
      t.string :mls_number
      t.string :listing_agent
      t.boolean :email_request_to_agent
      t.boolean :requested
      t.boolean :confirmed
      t.decimal :list_price

      t.timestamps
    end
  end
end
