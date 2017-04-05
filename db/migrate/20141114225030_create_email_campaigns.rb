class CreateEmailCampaigns < ActiveRecord::Migration
  def change
    create_table :email_campaigns do |t|
      t.string :title
      t.text :content
      t.string :image
      t.string :contacts
      t.datetime :scheduled_delivery_at
      t.datetime :delivered_at
      t.integer :user_id
      t.boolean :delivered

      t.timestamps
    end
  end
end
