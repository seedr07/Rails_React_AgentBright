class AddShowBetaFeaturesToUser < ActiveRecord::Migration

  def change
    add_column :users, :show_beta_features, :boolean, default: false, null: false
  end

end
