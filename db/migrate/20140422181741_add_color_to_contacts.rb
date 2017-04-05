class AddColorToContacts < ActiveRecord::Migration
  
  def change
    add_column :contacts, :avatar_color, :integer, default: 0
  end

end
