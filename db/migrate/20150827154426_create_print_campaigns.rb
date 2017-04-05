class CreatePrintCampaigns < ActiveRecord::Migration
  def change
    create_table :print_campaigns do |t|
      t.string :name
      t.integer :title
      t.integer :recipient_type
      t.string :label_size
      t.integer :user_id
      t.integer :contact_id
      t.integer :lead_id
      t.boolean :printed
      t.string :groups,         default: [],              array: true
      t.integer :grades,        default: [],              array: true
      t.text :contacts
      t.integer :quantity
      t.datetime :pdf_created_at
      t.datetime :printed_at

      t.timestamps null: false
    end
  end
end
