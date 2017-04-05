class AddGroupsGradesToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :selected_groups, :string, default: [],              array: true
    add_column :email_campaigns, :selected_grades, :integer, default: [],              array: true
  end
end
