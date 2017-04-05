class AddCustomCountColumnToUser < ActiveRecord::Migration
  def change
  	add_column :users, :ungraded_contacts_count, :integer, default: 0

  	User.reset_column_information
  	User.all.each do |u|
  		u.update_attribute :ungraded_contacts_count, u.contacts.where("grade is null").count
  	end

  end
end
