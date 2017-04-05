class AddCallAndVisitDatesToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :last_called_at, :date
    add_column :contacts, :next_call_at, :date
    add_column :contacts, :last_visited_at, :date
    add_column :contacts, :next_visit_at, :date
  end
end
