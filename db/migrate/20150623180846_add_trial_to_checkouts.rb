class AddTrialToCheckouts < ActiveRecord::Migration

  def change
    add_column :checkouts, :trial, :boolean, default: true, null: false
  end

end
