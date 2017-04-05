class CreateInboxMessageActivities < ActiveRecord::Migration
  def change
    create_table :inbox_message_activities do |t|
      t.string :activity_event
      t.datetime :ts
      t.references :inbox_message, index: true
      t.timestamps
    end
  end
end
