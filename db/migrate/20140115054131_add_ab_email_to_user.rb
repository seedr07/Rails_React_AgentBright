class AddAbEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :ab_email_address, :string, null: false
  end
end
