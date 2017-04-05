class CreateMktcampaigns < ActiveRecord::Migration
  def change
    create_table :mktcampaigns do |t|
      t.string :name
      t.string :type
      t.date :start_date_at
      t.date :end_date_at
      t.decimal :cost
      t.boolean :recurring
      t.string :frequency

      t.timestamps
    end
  end
end
