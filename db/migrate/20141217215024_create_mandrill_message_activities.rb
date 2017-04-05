class CreateMandrillMessageActivities < ActiveRecord::Migration
  def change
    create_table :mandrill_message_activities do |t|
      t.string :message_event, default: ""
      t.string :ip, default: ""
      t.string :location, default: ""
      t.string :ua, default: ""
      t.string :url, dfault: ""
      t.integer :ts
      t.references :mandrill_message, index: true

      t.timestamps
    end
  end
end
