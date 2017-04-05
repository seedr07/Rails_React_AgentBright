class AddClosingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :number_of_closed_leads_YTD, :integer, default: 0
  end
end
