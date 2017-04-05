class AddMandrillMetricsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :mandrill_email_interactions, :string, default: ""
  end
end
