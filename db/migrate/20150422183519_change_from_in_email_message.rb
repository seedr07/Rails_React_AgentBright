class ChangeFromInEmailMessage < ActiveRecord::Migration

  def change
    add_column :email_messages, :from_name, :string
    rename_column :email_messages, :from, :from_email
  end

end
