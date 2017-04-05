class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.references :owner, polymorphic: true
      t.string :number
      t.string :number_type
      t.boolean :primary?

      t.timestamps
    end
  end
end
