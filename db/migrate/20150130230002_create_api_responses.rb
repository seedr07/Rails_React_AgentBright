class CreateApiResponses < ActiveRecord::Migration
  def change
    create_table :api_responses do |t|
      t.datetime :fullcontact_last_called
      t.string :fullcontact_status
      t.string :fullcontact_message
      t.datetime :kimono_last_called
      t.string :kimono_status
      t.string :kimono_message
      t.datetime :inboxapp_last_called
      t.string :inboxapp_status
      t.string :inboxapp_message
      t.datetime :mandrill_last_called
      t.string :mandrill_status
      t.string :mandrill_message
      t.datetime :twilio_last_called
      t.string :twilio_status
      t.string :twilio_message
      t.datetime :stripe_last_called
      t.string :stripe_status
      t.string :stripe_message

      t.timestamps
    end
  end
end
