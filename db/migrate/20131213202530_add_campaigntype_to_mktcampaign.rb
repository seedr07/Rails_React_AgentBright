class AddCampaigntypeToMktcampaign < ActiveRecord::Migration
  def change
    add_column :mktcampaigns, :campaigntype, :string
  end
end
