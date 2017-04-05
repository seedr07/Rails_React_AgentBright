class AddIdsToMktcampaigns < ActiveRecord::Migration
  def change
    add_column :mktcampaigns, :media_id, :integer
    add_column :mktcampaigns, :frequency_id, :integer
  end
end
