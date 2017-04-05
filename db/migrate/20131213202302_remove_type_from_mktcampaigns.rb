class RemoveTypeFromMktcampaigns < ActiveRecord::Migration
  def change
    remove_column :mktcampaigns, :type, :string
  end
end
