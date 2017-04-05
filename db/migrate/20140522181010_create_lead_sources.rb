class CreateLeadSources < ActiveRecord::Migration
  def change
    create_table :lead_sources do |t|
      t.string :name
      t.references :lead_type, index: true

      t.timestamps
    end
  end
end
