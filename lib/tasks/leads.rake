desc 'Tasks related to the Lead model'
namespace :leads do

  task send_next_action_reminder_sms_messages: :environment do
    User.send_all_next_action_reminder_sms_messages
  end

  task :populate_lead_sources_and_types => :environment do
    LeadType.create(name: "Floor Time")
    LeadType.create(name: "Referral - From Database")
    LeadType.create(name: "Referral - From Business Network")
    LeadType.create(name: "Referral - From Realtor")
    LeadType.create(name: "Listing Inquiry")
    LeadType.create(name: "Advertising")
    LeadType.create(name: "Open House")
    LeadType.create(name: "Organization")
    LeadType.create(name: "Event")
    LeadType.create(name: "Geographic Farming")
    LeadType.create(name: "Marketing Campaign")
    LeadType.create(name: "Repeat Client")

    social_media = LeadType.create(name: "Social Media")
    real_estate_profile = LeadType.find_by(name: "Real Estate Profile")

    LeadSource.create(name: "Facebook", lead_type: social_media)
    LeadSource.create(name: "Twitter", lead_type: social_media)
    LeadSource.create(name: "LinkedIn", lead_type: social_media)
    LeadSource.create(name: "Other", lead_type: social_media)
    LeadSource.create(name: "Zillow", lead_type: real_estate_profile)
    LeadSource.create(name: "Realtor.com", lead_type: real_estate_profile)
    LeadSource.create(name: "Other", lead_type: real_estate_profile)

    trulia1 = LeadSource.find_by(name: "trulia1")
    trulia1.name = "Trulia"
    trulia1.save!
  end

end
