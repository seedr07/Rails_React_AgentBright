class AddLastCursorToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_cursor, :string
  end
end
