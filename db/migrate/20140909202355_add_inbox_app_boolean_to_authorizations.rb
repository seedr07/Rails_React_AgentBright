class AddInboxAppBooleanToAuthorizations < ActiveRecord::Migration
  
  def change
    add_column :authorizations, :via_inbox_app, :boolean, default: false
  end

end
