class AddShowNarrowMainNavBarToUser < ActiveRecord::Migration
  def change
  	add_column :users, :show_narrow_main_nav_bar, :boolean, :default => false
  end
end
