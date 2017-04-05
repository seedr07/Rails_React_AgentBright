class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.references :contact, index: true
      t.references :user, index: true
      t.integer :status
      t.string :client_type
      t.boolean :rental
      t.string :lead_type
      t.string :lead_source
      t.date :incoming_lead_at
      t.integer :initial_agent_valuation
      t.integer :current_price
      t.integer :closing_price
      t.date :closing_date_at
      t.decimal :total_commission_percentage
      t.decimal :agent_commission_percentage
      t.integer :stage
      t.text :notes

      t.timestamps
    end
  end
end
