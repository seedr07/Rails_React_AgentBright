class ChangePropertyTypeToInteger < ActiveRecord::Migration
  
  def change
    remove_column :properties, :property_type
    add_column :properties, :property_type, :integer
  end

end