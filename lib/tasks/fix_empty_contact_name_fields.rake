desc "fix empty contact name fields"
task :fix_empty_contact_name_fields => :environment do

  contacts = Contact.all
  contacts.each do |contact|
    contact.name = contact.full_name
    contact.save!
  end
end