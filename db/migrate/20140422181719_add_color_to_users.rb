class AddColorToUsers < ActiveRecord::Migration

  def change
    add_column :users, :avatar_color, :integer, default: 0
  end
  
end
