# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Media.create!(:media_type => "Newspaper", :num_order => 1)
Media.create!(:media_type => "Print Flyer", :num_order => 2)
Media.create!(:media_type => "Internet", :num_order => 3)
Media.create!(:media_type => "Email", :num_order => 4)
Media.create!(:media_type => "Social  Media", :num_order => 5)
Media.create!(:media_type => "Radio", :num_order => 6)
Media.create!(:media_type => "Television", :num_order => 7)

Frequency.create!(:freq_type => "One-off", :freq_order => 1)
Frequency.create!(:freq_type => "Weekly", :freq_order => 2)
Frequency.create!(:freq_type => "Bi-weekly", :freq_order => 3)
Frequency.create!(:freq_type => "Monthly", :freq_order => 4)
Frequency.create!(:freq_type => "Quarterly", :freq_order => 5)
Frequency.create!(:freq_type => "Annually", :freq_order => 6)

# LeadType.create!(name: "Floor Time")
# LeadType.create!(name: "Referral - From Database")
# LeadType.create!(name: "Referral - From Business Network")
# LeadType.create!(name: "Referral - From Realtor")
# LeadType.create!(name: "Listing Inquiry")
# LeadType.create!(name: "Advertising")
# LeadType.create!(name: "Open House")
# LeadType.create!(name: "Organization")
# LeadType.create!(name: "Event")
# social_media        = LeadType.create!(name: "Social Media")
# real_estate_profile = LeadType.create!(name: "Real Estate Profile")
# LeadType.create!(name: "Geographic Farming")
# LeadType.create!(name: "Marketing Campaign")
# LeadType.create!(name: "Repeat Client")

# LeadSource.create!(name: "Facebook", lead_type: social_media)
# LeadSource.create!(name: "Twitter", lead_type: social_media)
# LeadSource.create!(name: "LinkedIn", lead_type: social_media)
# LeadSource.create!(name: "Other Social Media", lead_type: social_media)
# LeadSource.create!(name: "Trulia", lead_type: real_estate_profile)
# LeadSource.create!(name: "Zillow", lead_type: real_estate_profile)
# LeadSource.create!(name: "Realtor.com", lead_type_id: real_estate_profile)
# LeadSource.create!(name: "Other Profile", lead_type_id: real_estate_profile)