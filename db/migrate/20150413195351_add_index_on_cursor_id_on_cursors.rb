class AddIndexOnCursorIdOnCursors < ActiveRecord::Migration
  def change
    add_index :cursors, :cursor_id
  end
end
