class ChangeListingAddressToText < ActiveRecord::Migration
  def change
    change_column :leads, :listing_address, :text
  end
end
