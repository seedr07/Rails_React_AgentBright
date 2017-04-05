class CreateFrequencies < ActiveRecord::Migration
  def change
    create_table :frequencies do |t|
      t.string :freq_type

      t.timestamps
    end
  end
end
