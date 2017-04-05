class ChangeReservedFieldsInCursors < ActiveRecord::Migration

  def change
    remove_column :cursors, :type
    add_column :cursors, :object_type, :text, null: false, default: ""
    add_column :cursors, :data, :text, null: false, default: ""
  end

end
