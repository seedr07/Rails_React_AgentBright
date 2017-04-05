class CreateLeadTypes < ActiveRecord::Migration
  def change
    create_table :lead_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
