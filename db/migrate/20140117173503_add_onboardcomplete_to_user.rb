class AddOnboardcompleteToUser < ActiveRecord::Migration
  def change
    add_column :users, :initial_setup, :boolean, :default => false
  end
end
