def ask(message)
  print message
  STDIN.gets.chomp.casecmp("yes").zero?
end

desc "remove old users and old associated data"
task remove_old_test_data: :environment do
  puts "This is nuclear. Only use this once. Do NOT use this "\
    "to remove additional users."

  user_ids_to_delete = [
    1, # john@example.com
    2, # jane@example.com
    3, # samsolo@example.com
    4, # eliexpired@example.com
    14, # neeraj@bigbinary.com
    16, # vipul@bigbinary.com
    17, # paul@bigbinary.com
    29, # stevechin@gmail.com
    39, # patrick@heyogrady.com
    44, # karabethneike@gmail.com
    52, # frank@testy.com
    55, # ogradypatrickj+ab@gmail.com
    58, # ogradypatrickj+59@gmail.com
    59, # patrick+2@agentbright.com
    60, # heyogrady@gmail.com
    61, # mike@test.com
    62, # patrick+personal@agentbright.com
    63, # patrick+personal@heyogrady.com
    64, # dd@gmail.com
    65, # georgegeorge@gmail.com
    66, # aa@gmail.com
    67, # bb@gmail.com
    68, # annieogrady22@hotmail.com
    69, # gregbphelps@gmail.com
    104, # anieohrady22@gmail.c
    34,
    35,
    36,
    37,
    38,
    40,
    41,
    42,
    46,
    48,
    49,
    50,
    51,
    53,
    54,
    57
  ]

  user_emails_to_delete = %w(
    john@example.com
    jane@example.com
    samsolo@example.com
    eliexpired@example.com
    neeraj@bigbinary.com
    vipul@bigbinary.com
    paul@bigbinary.com
    stevechin@gmail.com
    patrick@heyogrady.com
    karabethneike@gmail.com
    frank@testy.com
    ogradypatrickj+ab@gmail.com
    ogradypatrickj+59@gmail.com
    patrick+2@agentbright.com
    heyogrady@gmail.com
    mike@test.com
    patrick+personal@agentbright.com
    patrick+personal@heyogrady.com
    dd@gmail.com
    georgegeorge@gmail.com
    aa@gmail.com
    bb@gmail.com
    annieogrady22@hotmail.com
    gregbphelps@gmail.com
    anieohrady22@gmail.c
  )

  associated_models = %w(
    authorizations
    leads
    checkouts
    contact_activities
    contacts
    csv_files
    cursors
    email_campaigns
    email_messages
    failed_api_imports
    goals
    images
    inbox_messages
    lead_emails
    lead_groups
    lead_settings
    mandrill_messages
    print_campaigns
    print_campaign_messages
    properties
    subscriptions
    tasks
    teammates
    teams
  )

  if ask("This command is VERY destructive, proceed? (yes, no): ")
    User.transaction do
      puts "\n#{'-' * 50}\nUsers: #{User.count}\nContacts: #{Contact.count}\n"\
        "Leads: #{Lead.count}\nActivities: #{Activity.count}\n#{'-' * 50}\n\n\n\n"
      delete_records_owned_by_users(user_ids_to_delete, associated_models)
      fix_leads_missing_state
      fix_leads_missing_created_by_user
      delete_users(user_emails_to_delete)
      puts "\n#{'-' * 50}\nUsers: #{User.count}\nContacts: #{Contact.count}\n"\
        "Leads: #{Lead.count}\nActivities: #{Activity.count}\n#{'-' * 50}\n\n\n\n"
    end
  end

end

def delete_records_owned_by_users(user_ids_to_delete, associated_models)
  puts "Deleting records..."
  user_ids_to_delete.each do |user_id|
    delete_records(associated_models, user_id)
  end
  puts "Records deleted."
end

def delete_records(models, user_id)
  puts "\n#{'-' * 50}\nUser ID: #{user_id}\n#{'-' * 50}"
  models.each do |model|
    delete_model_records(model, user_id)
  end
end

def delete_model_records(model, user_id)
  puts "Deleting #{model.pluralize}..."
  records = model.classify.constantize.where(user_id: user_id)

  puts "Found #{records.count} #{model.pluralize}"

  records.each do |record|
    puts "#{model.capitalize} ID: #{record.id}"

    puts "Checking for associated activities..."
    delete_public_activities(model, record.id)

    puts "Deleting #{model}..."
    record.destroy
    puts "#{model.capitalize} deleted."
  end
end

def delete_public_activities(model, record_id)
  trackable_activities = PublicActivity::Activity.where(
    trackable_id: record_id,
    trackable_type: model.classify
  )
  if trackable_activities
    trackable_activities.destroy_all
  end

  recipient_activities = PublicActivity::Activity.where(
    recipient_id: record_id,
    recipient_type: model.classify
  )
  if recipient_activities
    recipient_activities.destroy_all
  end

  associable_activities = PublicActivity::Activity.where(
    associable_id: record_id,
    associable_type: model.classify
  )
  if associable_activities
    associable_activities.destroy_all
  end
end

def fix_leads_missing_state
  puts "\n\n\n\n\n#{'-' * 50}\nFixing leads missing state...\n#{'-' * 50}"
  updated_state = 0
  Lead.where(state: nil).each do |lead|
    updated_state = updated_state + 1
    puts "Updating Lead #{lead.id}..."
    lead.update_columns(state: "claimed")
  end
  puts "Complete. #{updated_state} leads updated."
end

def fix_leads_missing_created_by_user
  puts "\n\n\n\n\n#{'-' * 50}\nFixing leads missing created_by_user...\n#{'-' * 50}"
  saved = 0
  deleted = 0
  Lead.where(created_by_user_id: nil).each do |lead|
    if lead.user_id
      saved = saved + 1
      puts "Updating Lead #{lead.id}..."
      lead.update!(created_by_user_id: lead.user_id)
    else
      deleted = deleted + 1
      puts "Deleting Lead #{lead.id}..."
      lead.destroy!
    end
  end
  puts "Complete. #{saved} saved & #{deleted} deleted."
end

def delete_users(user_emails_to_delete)
  puts "\n\n\n\n\n#{'-' * 50}\nStarting with #{User.count} users.\n#{'-' * 50}"
  User.all.each do |user|
    if user_emails_to_delete.include?(user.email)
      delete_activities_owned_by_user(user)
      puts "Deleting #{user.email}..."
      user.destroy!
    end
  end
  puts "\n#{'-' * 50}\nDeleting users complete. There are now #{User.count} users.\n#{'-' * 50}"
end

def delete_activities_owned_by_user(user)
  puts "Deleting #{user.email} activities..."
  PublicActivity::Activity.where(owner_type: "User").where(owner_id: user.id).destroy_all
end
