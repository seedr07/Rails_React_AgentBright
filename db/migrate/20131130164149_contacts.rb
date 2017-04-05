class Contacts < ActiveRecord::Migration
  def change
    create_table(:contacts) do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zip
      t.string :spouse
      t.string :envelope_salutation
      t.string :letter_salutation
      t.string :company
      t.string :profession
      t.integer :grade
      t.string :mobile_phone
      t.datetime :last_contacted_at
      t.integer :minutes_since_last_contacted
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
