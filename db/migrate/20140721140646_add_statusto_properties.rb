class AddStatustoProperties < ActiveRecord::Migration
  def change
    add_column :properties, :level_of_interest, :string
  end
end
