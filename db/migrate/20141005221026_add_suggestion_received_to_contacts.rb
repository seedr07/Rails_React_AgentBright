class AddSuggestionReceivedToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :suggestion_received, :datetime
  end
end
