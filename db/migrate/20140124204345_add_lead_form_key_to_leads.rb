class AddLeadFormKeyToLeads < ActiveRecord::Migration
  def change
    add_column :users, :lead_form_key, :string
  end
end
