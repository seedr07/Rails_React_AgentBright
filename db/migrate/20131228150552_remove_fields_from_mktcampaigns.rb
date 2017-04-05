class RemoveFieldsFromMktcampaigns < ActiveRecord::Migration
  def change
    remove_column :mktcampaigns, :frequency, :string
    remove_column :mktcampaigns, :campaigntype, :string
  end
end
