class AddNewFieldToFrequency < ActiveRecord::Migration
  def change
    add_column :frequencies, :freq_order, :integer
  end
end
