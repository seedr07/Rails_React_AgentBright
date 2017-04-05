class FixSpouseName < ActiveRecord::Migration

  def self.up
    rename_column :contacts, :spouse, :spouse_first_name
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end

