class DropDescriptionFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :description
  end
end
