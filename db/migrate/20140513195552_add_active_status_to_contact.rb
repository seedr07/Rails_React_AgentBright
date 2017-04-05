class AddActiveStatusToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :active, :boolean, default: true
    add_column :contacts, :inactive_at, :datetime
  end
end
