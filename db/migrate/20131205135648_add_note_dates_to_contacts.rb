class AddNoteDatesToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :last_note_sent_at, :date
    add_column :contacts, :next_note_at, :date
  end
end
