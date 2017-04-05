class FixForeignKeyInCursors < ActiveRecord::Migration[5.0]

  def change
    remove_foreign_key :cursors, :users
    add_foreign_key :cursors, :users, on_delete: :cascade
  end

end
