class AddSocialprofileurlsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :suggested_facebook_url, :string
    add_column :contacts, :suggested_linkedin_url, :string
    add_column :contacts, :suggested_twitter_url, :string
    add_column :contacts, :suggested_googleplus_url, :string
    add_column :contacts, :suggested_instagram_url, :string
    add_column :contacts, :suggested_youtube_url, :string
  end
end
