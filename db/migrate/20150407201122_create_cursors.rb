class CreateCursors < ActiveRecord::Migration
  def change
    create_table :cursors do |t|
      t.references :user, index: true
      t.string :cursor_id
      t.string :type
      t.string :object_id
      t.string :event
      t.text :attributes

      t.timestamps null: false
    end
    add_foreign_key :cursors, :users
  end
end
