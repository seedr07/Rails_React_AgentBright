class CreateContingencies < ActiveRecord::Migration
  def change
    create_table :contingencies do |t|
      t.references :contract, index: true
      t.string :name
      t.string :status

      t.timestamps
    end
  end
end
