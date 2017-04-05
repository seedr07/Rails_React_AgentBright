class AddNewFieldToMedia < ActiveRecord::Migration
  def change
     add_column :media, :num_order, :integer
  end
end
