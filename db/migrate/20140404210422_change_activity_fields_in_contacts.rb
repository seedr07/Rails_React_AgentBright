class ChangeActivityFieldsInContacts < ActiveRecord::Migration
  def change
    change_column :contacts, :last_note_sent_at, :datetime
    change_column :contacts, :last_called_at, :datetime
    change_column :contacts, :last_visited_at, :datetime
    change_column :contacts, :next_note_at, :datetime
    change_column :contacts, :next_call_at, :datetime
    change_column :contacts, :next_visit_at, :datetime
  end
end
