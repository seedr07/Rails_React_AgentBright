class RemoveAttributesFromCursors < ActiveRecord::Migration
  def up
    remove_column :cursors, :attributes
  end
  def down
    add_column  :cursors, :attributes, :string
  end
end
