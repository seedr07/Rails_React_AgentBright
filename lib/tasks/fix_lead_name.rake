desc 'Fixing Lead Name'
task :fix_lead_name => :environment do
  Lead.all.each do |lead|
    naming_service = LeadAttributesCalculationService.new(lead)
    naming_service.set_lead_name
    renamed_lead = naming_service.lead
    renamed_lead.save
  end
end