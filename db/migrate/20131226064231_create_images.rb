class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|

      t.references :user
      t.references :attachable, polymorphic: true
      t.string :file
      
      t.timestamps
    end
  end
end
