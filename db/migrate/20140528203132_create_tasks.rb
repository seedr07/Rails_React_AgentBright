class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :subject
      t.integer :assigned_to
      t.datetime :due_date
      t.boolean :completed?
      t.references :taskable, polymorphic: true
      t.string :taskable_type
      t.references :user, index: true

      t.timestamps
    end
    add_index :tasks, [:taskable_id, :taskable_type]
  end
end
