class AddGradedAtToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :graded_at, :datetime
  end
end
