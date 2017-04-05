class AddAssociablePolymorphicColumnToActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.references :associable, polymorphic: true
    end
  end
end
