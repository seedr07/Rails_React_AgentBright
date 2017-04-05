class AddRecepientSelectorTypeToEmailCamapigns < ActiveRecord::Migration

  def change
    add_column :email_campaigns, :recipient_selector_type, :string
  end

end
