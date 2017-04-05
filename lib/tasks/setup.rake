desc "Ensure that code is not running in production environment"
task :not_production do
  raise "do not run in production" if Rails.env.production?
end

desc "Sets up the project by running migration and populating sample data"
task setup: [:environment, :not_production, "db:drop", "db:create", "db:migrate"] do
  ["setup_sample_data"].each { |cmd| system "rake #{cmd}" }
end

desc "Sets up the project by running migration and populating sample data, including market data"
task setup_full: [:environment, :not_production, "db:drop", "db:create", "db:migrate"] do
  ["setup_sample_data", "market_data:load_data"].each { |cmd| system "rake #{cmd}" }
end

def delete_all_records_from_all_tables
  puts "Deleting all records from all tables...\n"

  puts "Clearing schema cache...\n"
  ActiveRecord::Base.connection.schema_cache.clear!

  puts "Requiring files...\n"
  Dir.glob(Rails.root + 'app/models/*.rb').sort.each { |file| require_dependency file }

  puts "\nDeleting all records...\n\n"
  ActiveRecord::Base.descendants.each do |klass|
    puts "  * deleting records in #{klass}...\n"
    klass.reset_column_information
    klass.delete_all
  end
  puts "\nFinished deleting records.\n"
end

desc "Delete all records and add many contacts sample data"
task setup_extra_contact_data: [:environment, :not_production] do
  delete_all_records_from_all_tables

  original_env = Rails.env # store current rails environment
  Rails.env = "rake" # set env to "rake" to temporarily disable fulcontact api

  puts "Adding sample data with 3000 contacts...\n\n"

  add_lead_types_and_sources
  add_users_and_subscriptions
  add_contacts_from_yaml
  add_goals
  add_contact_activities
  add_leads
  add_tasks
  add_contracts
  add_lead_groups
  add_email_campaigns

  Rails.env = original_env # reset to original env

  add_john_jane_as_teammates
  puts "\n\nSample data with 3000 contacts was added successfully."
end

desc "Deletes all records and populates sample data"
task setup_sample_data: [:environment, :not_production] do
  delete_all_records_from_all_tables

  original_env = Rails.env # store current rails environment
  Rails.env = "rake" # set env to "rake" to temporarily disable fulcontact api

  puts "Adding sample data...\n\n"

  add_lead_types_and_sources
  add_users_and_subscriptions
  add_contacts
  add_goals
  add_contact_activities
  add_leads
  add_tasks
  add_contracts
  add_lead_groups
  add_email_campaigns

  Rails.env = original_env # reset to original env

  add_john_jane_as_teammates
  puts "\n\nSample data was added successfully."
end

def add_lead_types_and_sources
  puts "  * Lead Types...\n"
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
  real_estate_profile = LeadType.create(name: "Real Estate Profile")

  puts "  * Lead Sources...\n"
  LeadSource.create(name: "Facebook", lead_type: social_media)
  LeadSource.create(name: "Twitter", lead_type: social_media)
  LeadSource.create(name: "LinkedIn", lead_type: social_media)
  LeadSource.create(name: "Other", lead_type: social_media)
  LeadSource.create(name: "Trulia", lead_type: real_estate_profile)
  LeadSource.create(name: "Zillow", lead_type: real_estate_profile)
  LeadSource.create(name: "Realtor.com", lead_type: real_estate_profile)
  LeadSource.create(name: "Other", lead_type: real_estate_profile)
end

def add_users_and_subscriptions
  puts "  * Plans...\n"
  Plan.transaction do
    @lite_plan = create_plan(
      sku: "lite",
      name: "Lite Plan",
      price_in_dollars: 29,
      short_description: "The plan to get you started on a budget.",
      description: "A long description.",
      featured: true
    )

    @standard_plan = create_plan(
      sku: "standard",
      name: "Standard Plan",
      price_in_dollars: 79,
      short_description: "The that gives you the best bang for your buck.",
      description: "A long description.",
      featured: true
    )

    @professional_plan = create_plan(
      sku: "professional",
      name: "Professional Plan",
      price_in_dollars: 129,
      short_description: "Enjoy every feature at your disposal.",
      description: "A long description.",
      featured: true
    )

    @discounted_annual_plan = create_plan(
      sku: Plan::DISCOUNTED_ANNUAL_PLAN_SKU,
      name: "Discounted Annual Plan",
      price_in_dollars: 790,
      short_description: "Everything you're used to, but a bit cheaper.",
      description: "A long description.",
      featured: false,
      annual: true
    )

    @free_plan = create_plan(
      sku: "free",
      name: "Free Plan",
      price_in_dollars: 0,
      short_description: "Totally free plan.",
      description: "A long description.",
      featured: false
    )
  end

  puts "  * Users...\n"
  User.transaction do
    @john = create_user(
      email: "john@example.com",
      name: "John Smith",
      first_name: "John",
      last_name: "Smith",
      mobile_number: "8605755306",
      city: "Essex",
      ab_email_address: "john@#{Rails.application.secrets.leads['agent_bright_me_email_domain']}",
      super_admin: true,
      initial_setup: true,
      commission_split_type: "Fee",
      broker_fee_per_transaction: 350,
      broker_fee_alternative: false,
      broker_fee_alternative_split: 20,
      per_transaction_fee_capped: true,
      transaction_fee_cap: 20,
      monthly_broker_fees_paid: 50,
      annual_broker_fees_paid: 600,
      subscription_account_status: 3,
      nylas_token: "H9qJMIzX45mxSqdhOkHOolIMBWXuRh",
      nylas_account_id: "1vp9hlbbf19jm550emi82dd7d",
      stripe_customer_id: "cus_6M4PXCczoJAAZ7",
      nilas_calendar_setting_id: "3gj6fwa1dp3fk3g801tx34ge5"
    )
    @jane = create_user(
      email: "jane@example.com",
      name: "Jane Jones",
      first_name: "Jane",
      last_name: "Jones",
      mobile_number: "8605756950",
      ab_email_address: "jane@#{Rails.application.secrets.leads['agent_bright_me_email_domain']}",
      super_admin: false,
      show_beta_features: true,
      subscription_account_status: 3,
      nylas_token: "Rs5GhEm8mULTVFU3LbPVPGLvPMy2Ma",
      nylas_account_id: "3sdlmdy4bnyy7rynd7ysuo8jy",
      nylas_connected_email_account: "jane.jones.agentbright@gmail.com",
      stripe_customer_id: "cus_6M4PRqU9KVkT8W"
    )
    @sam = create_user(
      email: "samsolo@example.com",
      name: "Sam Solo",
      first_name: "Sam",
      last_name: "Solo",
      mobile_number: "8605756950",
      initial_setup: true,
      ab_email_address: "sam@#{Rails.application.secrets.leads['agent_bright_me_email_domain']}",
      super_admin: true,
      subscription_account_status: 3,
      nylas_token: "DOPeu22TIn8zgepY71tVo8laVb8J35",
      nylas_account_id: "3sdlmdy4bnyy7rynd7ysuo8jy",
      nylas_connected_email_account: "sam.solo.agentbright@gmail.com",
      stripe_customer_id: "cus_6M4P40RNZGKS8L"
    )
    @eli = create_user(
      email: "eliexpired@example.com",
      name: "Eli Expired",
      first_name: "Eli",
      last_name: "Expired",
      mobile_number: "8605756950",
      initial_setup: true,
      ab_email_address: "eli_expired@#{Rails.application.secrets.leads['agent_bright_me_email_domain']}",
      super_admin: true
    )
  end

  puts "  * Checkouts...\n"
  Checkout.transaction do
    create_checkout(
      user: @john,
      plan: @free_plan
    )
    create_checkout(
      user: @jane,
      plan: @free_plan
    )
    create_checkout(
      user: @sam,
      plan: @free_plan
    )
  end

  puts "  * Subscriptions...\n"
  Subscription.transaction do
    create_subscription(
      user: @john,
      plan: @free_plan,
      plan_type: "Plan",
      next_payment_amount: 0,
      next_payment_on: Date.new(2016, 6, 2),
      stripe_id: "sub_6M4P9rlaXT6DF8"
    )
    create_subscription(
      user: @jane,
      plan: @free_plan,
      plan_type: "Plan",
      next_payment_amount: 0,
      next_payment_on: Date.new(2016, 6, 2),
      stripe_id: "sub_6M4PhdAzpN0H86"
    )
    create_subscription(
      user: @sam,
      plan: @free_plan,
      plan_type: "Plan",
      next_payment_amount: 0,
      next_payment_on: Date.new(2016, 6, 2),
      stripe_id: "sub_6M4PFZfzs4Kg9f"
    )
  end
end

def add_contacts
  puts "  * Contacts...\n"
  Contact.transaction do
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: "Blair",
      last_name: "Sturm",
      grade: 0,
      graded_at: Time.current,
      addresses_attributes: [
        street: "45 Hollow Drive",
        city: "Hartford",
        state: "CT"
      ],
      phone_numbers_attributes: [
        { number: "214-454-1111", number_type: "Mobile" },
        { number: "214-454-3333", number_type: "Work" },
        { number: "214-454-2222", number_type: "Home" },
        { number: "214-454-4444", number_type: "Fax" }
      ],
      email_addresses_attributes: [
        email: "sturmblm@gmail.com", email_type: "Primary"
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: "Mike",
      last_name: "D'Fantis",
      grade: 2,
      graded_at: Time.current,
      spouse_first_name: "Katie",
      addresses_attributes: [
        street: "79 Long Hill Road.",
        city: "Madison",
        state: "CT",
        zip: "06443"
      ],
      phone_numbers_attributes: [
        number: "3092020294", number_type: "Mobile"
      ],
      email_addresses_attributes: [
        { email: "mdfantis@gmail.com", email_type: "Work" },
        { email: "mdfantiswork@gmail.com", email_type: "Work" },
        { email: "mdfantisper@gmail.com", email_type: "Personal" },
        { email: "mdfantisother@gmail.com", email_type: "Other" }
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: "Katie",
      last_name: "Lozar",
      grade: 0,
      graded_at: Time.current,
      spouse_first_name: "Dave",
      addresses_attributes: [
        street: "67 West Main St.",
        city: "Branford",
        state: "CT",
        zip: "06405"
      ],
      phone_numbers_attributes: [
        { number: "4342939554", number_type: "Mobile" },
        { number: "434-939-2222", number_type: "Home" }
      ],
      email_addresses_attributes: [
        { email: "klozar@gmail.com", email_type: "Work" },
        { email: "katiework@gmail.com", email_type: "Personal" }
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: "Cullen",
      last_name: "Hagan",
      grade: 1,
      graded_at: Time.current,
      spouse_first_name: "Kate",
      addresses_attributes: [
        street: "92 Deer Run Road.",
        city: "Essex",
        state: "CT",
        zip: "06426"
      ],
      phone_numbers_attributes: [number: "8602277899", number_type: "Mobile"],
      email_addresses_attributes: [
        email: "sturmblm@gmail.com",
        email_type: "Personal"
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: "Beth",
      last_name: "Boring",
      grade: 3,
      graded_at: Time.current,
      spouse_first_name: "Van",
      addresses_attributes: [
        street: "3544 Crown Point Road",
        city: "Westbrook",
        state: "CT",
        zip: "06498"
      ],
      phone_numbers_attributes: [number: "8605756950", number_type: "Mobile"],
      email_addresses_attributes: [
        email: "beth.boring.agentbright@gmail.com",
        email_type: "Work"
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: "Stuart",
      last_name: "Dowsett",
      grade: 2,
      graded_at: Time.current,
      spouse_first_name: "Kate",
      addresses_attributes: [
        street: "49 Maple Ave., Apt 19",
        city: "New London",
        state: "CT",
        zip: "06320"
      ],
      phone_numbers_attributes: [number: "8602275555", number_type: "Mobile"],
      email_addresses_attributes: [
        email: "SDowsett@gmail.com",
        email_type: "Personal"
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: 'Garrett',
      last_name: "Hayes",
      grade: 3,
      graded_at: Time.current,
      spouse_first_name: 'Mary',
      addresses_attributes: [
        street: '85 AppleWalnut Way',
        city: 'Old Saybrook',
        state: 'Ct',
        zip: '99999'
      ],
      phone_numbers_attributes: [number: '8606761287', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'Ghayes1212@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: 'Barbara',
      last_name: "Wiltsie",
      grade: 0,
      graded_at: Time.current,
      spouse_first_name: 'John',
      addresses_attributes: [
        street: 'Seaside Street.',
        city: 'Old Lyme',
        state: 'Ct',
        zip: '06371'
      ],
      phone_numbers_attributes: [number: '8606693434', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'BWiltsie8910@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: 'Mickey',
      last_name: "Mouse",
      grade: 5,
      graded_at: Time.current,
      spouse_first_name: 'Minnie',
      addresses_attributes: [
        street: 'Anywhere Usa',
        city: 'Nowhere',
        state: 'Ct',
        zip: '99999'
      ],
      phone_numbers_attributes: [number: '8609999999', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'MMouse12345@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: 'Corinne',
      last_name: "Johnson",
      grade: 2,
      graded_at: Time.current,
      spouse_first_name: 'Robert',
      addresses_attributes: [
        street: 'Birch Drive',
        city: 'Old Saybrook',
        state: 'CT',
        zip: '06578'
      ],
      phone_numbers_attributes: [number: '8601666666', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'CJohnson44445@gmail.com',
        email_type: 'Personal'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Smith"),
      first_name: 'Miriam',
      last_name: "Hobbs",
      grade: 1,
      graded_at: Time.current,
      spouse_first_name: 'Carlos',
      addresses_attributes: [
        street: '16 Broadway',
        city: 'Colchester',
        state: 'Ct',
        zip: '06415'
      ],
      phone_numbers_attributes: [number: '860-785-5604', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'MHobbs5@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Jones"),
      first_name: 'Jill',
      last_name: "McDonald",
      grade: 3,
      graded_at: Time.current,
      spouse_first_name: 'Michael',
      addresses_attributes: [
        street: '85 Quartz Way',
        city: 'Lyme',
        state: 'CT',
        zip: '06371'
      ],
      phone_numbers_attributes: [number: '8604441212', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'annieogrady22+mcdonald@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Jones"),
      first_name: 'Jennifer',
      last_name: "Juniper",
      grade: 0,
      graded_at: Time.current,
      spouse_first_name: 'John',
      addresses_attributes: [
        street: '59 Iron Street.',
        city: 'Lyme',
        state: 'CT',
        zip: '06371'
      ],
      phone_numbers_attributes: [number: '8608881234', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'annieogrady22+juniper@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Jones"),
      first_name: 'Bugs',
      last_name: "Bunny",
      grade: 5,
      graded_at: Time.current,
      spouse_first_name: 'Lola',
      addresses_attributes: [
        street: 'Anywhere Usa',
        city: 'Lyme',
        state: 'CT',
        zip: '06371'
      ],
      phone_numbers_attributes: [number: '8607777777', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'BugsBunny12345@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Jones"),
      first_name: 'Jimmy',
      last_name: "Jeffrey",
      grade: 2,
      graded_at: Time.current,
      spouse_first_name: 'Robert',
      addresses_attributes: [
        street: 'Limestone Drive',
        city: 'Lyme',
        state: 'CT',
        zip: '06371'
      ],
      phone_numbers_attributes: [number: '8601666666', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'annieogrady22+JJeffrey@gmail.com',
        email_type: 'Personal'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Jones"),
      first_name: 'Jenny',
      last_name: "Mooney",
      grade: 1,
      graded_at: Time.current,
      spouse_first_name: 'Carlos',
      addresses_attributes: [
        street: '16 Sandstone Lane',
        city: 'Lyme',
        state: 'CT',
        zip: '06371'
      ],
      phone_numbers_attributes: [number: '860-888-5555', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'annieogrady22+MJMooney@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Solo"),
      first_name: 'Serena',
      last_name: "Sayes",
      grade: 3,
      graded_at: Time.current,
      spouse_first_name: 'Michael',
      addresses_attributes: [
        street: '85 Broccli Way',
        city: 'Louisville',
        state: 'TN',
        zip: '37777'
      ],
      phone_numbers_attributes: [number: '8651231212', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'annieogrady22+sayes@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Solo"),
      first_name: 'Missy',
      last_name: "Hogan",
      grade: 0,
      graded_at: Time.current,
      spouse_first_name: 'John',
      addresses_attributes: [
        street: 'Tomato Street.',
        city: 'Louisville',
        state: 'TN',
        zip: '37777'
      ],
      phone_numbers_attributes: [number: '8659991234', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'annieogrady22+hogan@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Solo"),
      first_name: 'Donald',
      last_name: "Duck",
      grade: 5,
      graded_at: Time.current,
      spouse_first_name: 'Daisy',
      addresses_attributes: [
        street: 'Anywhere Usa',
        city: 'Nowhere',
        state: 'Ct',
        zip: '99999'
      ],
      phone_numbers_attributes: [number: '8659999999', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'Donald12345@gmail.com',
        email_type: 'Work'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Solo"),
      first_name: 'Renee',
      last_name: "James",
      grade: 2,
      graded_at: Time.current,
      spouse_first_name: 'Robert',
      addresses_attributes: [
        street: 'Carrot Drive',
        city: 'Louisville',
        state: 'TN',
        zip: '37777'
      ],
      phone_numbers_attributes: [number: '8651666666', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'annieogrady22+ReneeJR44445@gmail.com',
        email_type: 'Personal'
      ]
    )
    create_contact(
      user: User.find_by(last_name: "Solo"),
      first_name: 'Melinda',
      last_name: "Mooney",
      grade: 1,
      graded_at: Time.current,
      spouse_first_name: 'Carlos',
      addresses_attributes: [
        street: '16 Squash Lane',
        city: 'Louisville',
        state: 'TN',
        zip: '37777'
      ],
      phone_numbers_attributes: [number: '865-777-5555', number_type: 'Mobile'],
      email_addresses_attributes: [
        email: 'annieogrady22+MJMooney@gmail.com',
        email_type: 'Work'
      ]
    )
  end
end

def add_goals
  puts "  * Goals...\n"
  Goal.transaction do
    create_goal(
      user: User.find_by(last_name: "Smith"),
      desired_annual_income: 100_000,
      est_business_expenses: 10_000,
      portion_of_agent_split: 80,
      gross_commission_goal: 137_500,
      avg_commission_rate: 3,
      gross_sales_vol_required: 4_583_333,
      avg_price_in_area: 200_000,
      annual_transaction_goal: 23,
      qtrly_transaction_goal: 5,
      monthly_transaction_goal: 2,
      referrals_for_one_close: 5,
      contacts_to_generate_one_referral: 20,
      contacts_need_per_month: 49,
      calls_required_wkly: 18,
      note_required_wkly: 25,
      total_weekly_effort: 15,
      visits_required_wkly: 8,
      daily_calls_goal: 5,
      daily_notes_goal: 7,
      daily_visits_goal: 2
    )
    create_goal(
      user: User.find_by(last_name: "Solo"),
      desired_annual_income: 70_000,
      est_business_expenses: 8_000,
      portion_of_agent_split: 80,
      gross_commission_goal: 93_600,
      avg_commission_rate: 3,
      gross_sales_vol_required: 3_088_800,
      avg_price_in_area: 200_000,
      annual_transaction_goal: 15,
      qtrly_transaction_goal: 4,
      monthly_transaction_goal: 1,
      referrals_for_one_close: 5,
      contacts_to_generate_one_referral: 20,
      contacts_need_per_month: 36,
      calls_required_wkly: 22,
      note_required_wkly: 18,
      total_weekly_effort: 9,
      visits_required_wkly: 3,
      daily_calls_goal: 4,
      daily_notes_goal: 3,
      daily_visits_goal: 2
    )
  end
end

def add_contact_activities
  puts "  * Contact Activities...\n"
  ContactActivity.transaction do
    create_contact_activity user: User.find_by(last_name: "Smith"),
                            activity_type: 'Call',
                            subject: 'Proactive Marketing Call',
                            contact: Contact.find_by(last_name: "Lozar"),
                            comments: 'Spoke about the new baby',
                            completed_at: Time.current - 80.days
    create_contact_activity user: User.find_by(last_name: "Smith"),
                            activity_type: 'Note',
                            subject: 'Proactive Marketing Note',
                            contact: Contact.find_by(last_name: "Lozar"),
                            comments: 'Attached a calvin and hobbes comic about snow',
                            completed_at: Time.current - 45.days
    create_contact_activity user: User.find_by(last_name: "Smith"),
                            activity_type: 'Visit',
                            subject: 'Proactive Marketing Visit',
                            contact: Contact.find_by(last_name: "Lozar"),
                            comments: 'Dropped by with an apple pie',
                            completed_at: Time.current - 15.days
    create_contact_activity user: User.find_by(last_name: "Smith"),
                            activity_type: 'Call',
                            subject: 'Proactive Marketing Call',
                            contact: Contact.find_by(last_name: "Sturm"),
                            comments: 'Talked about the fantasy football league',
                            completed_at: Time.current - 8.days
    create_contact_activity user: User.find_by(last_name: "Smith"),
                            activity_type: 'Note',
                            subject: 'Proactive Marketing Note',
                            contact: Contact.find_by(last_name: "Sturm"),
                            comments: 'Thanked him for a great time in NYC',
                            completed_at: Time.current - 28.days
    create_contact_activity user: User.find_by(last_name: "Smith"),
                            activity_type: 'Visit',
                            subject: 'Proactive Marketing Visit',
                            contact: Contact.find_by(last_name: "Sturm"),
                            comments: 'Dropped by work, had a great conversation about new girlfriend named Valarie',
                            completed_at: Time.current - 90.days
    create_contact_activity user: User.find_by(last_name: "Smith"),
                            activity_type: 'Call',
                            subject: 'Proactive Marketing Call',
                            contact: Contact.find_by(last_name: "D'Fantis"),
                            comments: 'Looking for a good painter to redo their ceilings',
                            completed_at: Time.current - 30.days
    create_contact_activity user: User.find_by(last_name: "Smith"),
                            activity_type: 'Visit',
                            subject: 'Proactive Marketing Note',
                            contact: Contact.find_by(last_name: "D'Fantis"),
                            comments: 'Sent an article about the benefits of heat pumps',
                            completed_at: Time.current - 2.days
    create_contact_activity user: User.find_by(last_name: "Smith"),
                            activity_type: 'Visit',
                            subject: 'Proactive Marketing Visit',
                            contact: Contact.find_by(last_name: "D'Fantis"),
                            comments: 'Dropped off some cookies, saw baby Rachel, she is almost walking',
                            completed_at: Time.current - 60.days
    create_contact_activity user: User.find_by(last_name: "Solo"),
                            activity_type: 'Call',
                            subject: 'Proactive Marketing Call',
                            contact: Contact.find_by(last_name: "Hogan"),
                            comments: 'Spoke about the new dog',
                            completed_at: Time.current - 28.days
    create_contact_activity user: User.find_by(last_name: "Solo"),
                            activity_type: 'Note',
                            subject: 'Proactive Marketing Note',
                            contact: Contact.find_by(last_name: "Hogan"),
                            comments: 'Attached a simpson comic about snow',
                            completed_at: Time.current - 2.days
    create_contact_activity user: User.find_by(last_name: "Solo"),
                            activity_type: 'Visit',
                            subject: 'Proactive Marketing Visit',
                            contact: Contact.find_by(last_name: "Sayes"),
                            comments: 'Dropped by with an apple pie',
                            completed_at: Time.current - 48.days
    create_contact_activity user: User.find_by(last_name: "Solo"),
                            activity_type: 'Call',
                            subject: 'Proactive Marketing Call',
                            contact: Contact.find_by(last_name: "Sayes"),
                            comments: 'Talked about the Antique Fair',
                            completed_at: Time.current - 28.days
    create_contact_activity user: User.find_by(last_name: "Solo"),
                            activity_type: 'Note',
                            subject: 'Proactive Marketing Note',
                            contact: Contact.find_by(last_name: "Sayes"),
                            comments: 'Thanked him for a great time in Asheville',
                            completed_at: Time.current - 2.days
    create_contact_activity user: User.find_by(last_name: "Solo"),
                            activity_type: 'Visit',
                            subject: 'Proactive Marketing Visit',
                            contact: Contact.find_by(last_name: "Mooney"),
                            comments: 'Dropped by work, had a great conversation about new boyfriend name Michael',
                            completed_at: Time.current - 38.days
    create_contact_activity user: User.find_by(last_name: "Solo"),
                            activity_type: 'Call',
                            subject: 'Proactive Marketing Call',
                            contact: Contact.find_by(last_name: "Mooney"),
                            comments: 'Looking for a good painter to redo their bathroom',
                            completed_at: Time.current - 28.days
    create_contact_activity user: User.find_by(last_name: "Solo"),
                            activity_type: 'Note',
                            subject: 'Proactive Marketing Note',
                            contact: Contact.find_by(last_name: "Mooney"),
                            comments: 'Sent an article about the benefits of heat pumps',
                            completed_at: Time.current - 4.days
    create_contact_activity user: User.find_by(last_name: "Solo"),
                            activity_type: 'Visit',
                            subject: 'Proactive Marketing Visit',
                            contact: Contact.find_by(last_name: "Sayes"),
                            comments: 'Dropped off some cookies, saw baby Samantha, she is almost talking',
                            completed_at: Time.current - 2.days
  end

  puts "  * Media...\n"
  Media.create(media_type: "Newspaper", num_order: 1)
  Media.create(media_type: "Print Flyer", num_order: 2)
  Media.create(media_type: "Internet", num_order: 3)
  Media.create(media_type: "Email", num_order: 4)
  Media.create(media_type: "Social  Media", num_order: 5)
  Media.create(media_type: "Radio", num_order: 6)
  Media.create(media_type: "Television", num_order: 7)

  puts "  * Frequency...\n"
  Frequency.create(freq_type: "One-off", freq_order: 1)
  Frequency.create(freq_type: "Weekly", freq_order: 2)
  Frequency.create(freq_type: "Bi-weekly", freq_order: 3)
  Frequency.create(freq_type: "Monthly", freq_order: 4)
  Frequency.create(freq_type: "Quarterly", freq_order: 5)
  Frequency.create(freq_type: "Annually", freq_order: 6)
end

def add_leads
  puts "  * Leads...\n"
  Lead.transaction do
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Lozar"),
      status: 0,
      client_type: "Buyer",
      min_price_range: 800000,
      max_price_range: 1000000,
      timeframe: 4,
      buyer_area_of_interest: "Essex",
      lead_type: LeadType.find_by(name: "Real Estate Profile"),
      lead_source: LeadSource.find_by(name: "Trulia"),
      buyer_prequalified: true,
      prequalification_amount: 1000000,
      state: "claimed",
      contacted_status: 0,
      incoming_lead_at: Time.current - 3.hours,
      initial_status_when_created: 0,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M212234",
        bedrooms: 3,
        bathrooms: 2,
        sq_feet: 2500,
        lot_size: 2,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Hayes"),
      status: 0,
      client_type: "Buyer",
      min_price_range: 100000,
      max_price_range: 300000,
      timeframe: 2,
      buyer_area_of_interest: "Madison",
      lead_type: LeadType.find_by(name: "Real Estate Profile"),
      lead_source: LeadSource.find_by(name: "Zillow"),
      buyer_prequalified: true,
      prequalification_amount: 150000,
      state: "claimed",
      contacted_status: 0,
      incoming_lead_at: Time.current - 3.days,
      initial_status_when_created: 0,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M212234",
        bedrooms: 3,
        bathrooms: 2,
        sq_feet: 2500,
        lot_size: 2,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Jones"),
      contact: Contact.find_by(last_name: "McDonald"),
      status: 0,
      client_type: "Buyer",
      min_price_range: 800000,
      max_price_range: 1000000,
      timeframe: 4,
      buyer_area_of_interest: "Essex",
      lead_type: LeadType.find_by(name: "Real Estate Profile"),
      lead_source: LeadSource.find_by(name: "Trulia"),
      buyer_prequalified: true,
      prequalification_amount: 1000000,
      state: "claimed",
      contacted_status: 0,
      incoming_lead_at: Time.current - 3.hours,
      initial_status_when_created: 0,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M212234",
        bedrooms: 3,
        bathrooms: 2,
        sq_feet: 2500,
        lot_size: 2,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Solo"),
      contact: Contact.find_by(last_name: "Sayes"),
      status: 0,
      client_type: "Buyer",
      min_price_range: 100000,
      max_price_range: 300000,
      timeframe: 2,
      buyer_area_of_interest: "Madison",
      lead_type: LeadType.find_by(name: "Real Estate Profile"),
      lead_source: LeadSource.find_by(name: "Zillow"),
      buyer_prequalified: true,
      prequalification_amount: 150000,
      state: "claimed",
      contacted_status: 0,
      incoming_lead_at: Time.current - 3.days,
      initial_status_when_created: 0,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M212234",
        bedrooms: 3,
        bathrooms: 2,
        sq_feet: 2500,
        lot_size: 2,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Jones"),
      contact: Contact.find_by(last_name: "Mooney"),
      status: 1,
      client_type: "Seller",
      amount_owed: 0,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.current - 90.days,
      properties_attributes: [
        list_price: 1600000,
        transaction_type: "Seller",
        property_type: 0,
        commission_type: "Percentage",
        commission_percentage: 3.00,
        original_list_date_at: Time.current - 90.days,
        listing_expires_at: Time.current + 90.days,
        mls_number: "M2342323",
        initial_agent_valuation: 1500000,
        initial_client_valuation: 2000000,
        address_attributes: {
          street: "45 Otter Cove Drive",
          city: "Old Saybrook",
          state: "CT",
          zip: "06475"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Lozar"),
      status: 1,
      client_type: "Seller",
      amount_owed: 0,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.current - 90.days,
      properties_attributes: [
        list_price: 1600000,
        transaction_type: "Seller",
        property_type: 0,
        commission_type: "Percentage",
        commission_percentage: 3.00,
        original_list_date_at: Time.current - 90.days,
        listing_expires_at: Time.current + 90.days,
        mls_number: "M2342323",
        initial_agent_valuation: 1500000,
        initial_client_valuation: 2000000,
        address_attributes: {
          street: "45 Otter Cove Drive",
          city: "Old Saybrook",
          state: "CT",
          zip: "06475"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Boring"),
      status: 1,
      client_type: "Seller",
      amount_owed: 0,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.current - 60.days,
      properties_attributes: [
        list_price: 700000,
        transaction_type: "Seller",
        property_type: 0,
        commission_type: "Percentage",
        commission_percentage: 3.00,
        original_list_date_at: Time.current - 60.days,
        listing_expires_at: Time.current + 120.days,
        mls_number: "M2342323",
        initial_agent_valuation: 685000,
        initial_client_valuation: 900000,
        address_attributes: {
          street: "59 Winthrop Road",
          city: "Madison",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Solo"),
      contact: Contact.find_by(last_name: "Mooney"),
      status: 2,
      client_type: "Seller",
      lead_type: LeadType.find_by(name: "Referral - From Database"),
      timeframe: 0,
      amount_owed: 170000.00,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.current - 90.days,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Seller",
        property_type: 0,
        commission_type: "Percentage",
        commission_percentage: 3.00,
        original_list_date_at: Time.current - 90.days,
        original_list_price: 200000.00,
        listing_expires_at: Time.current + 90.days,
        mls_number: "M212234",
        initial_agent_valuation: 185000,
        initial_client_valuation: 250000,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Solo"),
      contact: Contact.find_by(last_name: "Mooney"),
      status: 2,
      client_type: "Buyer",
      lead_type: LeadType.find_by(name: "Referral - From Database"),
      min_price_range: 200000,
      max_price_range: 300000,
      timeframe: 1,
      buyer_area_of_interest: "Madison/Guilford",
      buyer_prequalified: true,
      prequalification_amount: 350000,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.zone.now - 24.minutes,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M212234",
        bedrooms: 3,
        bathrooms: 2,
        sq_feet: 2500,
        lot_size: 2,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "D'Fantis"),
      status: 2,
      client_type: "Seller",
      lead_type: LeadType.find_by(name: "Referral - From Database"),
      timeframe: 0,
      amount_owed: 170000.00,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.current - 90.days,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Seller",
        property_type: 0,
        commission_type: "Percentage",
        commission_percentage: 3.00,
        original_list_date_at: Time.current - 90.days,
        original_list_price: 200000.00,
        listing_expires_at: Time.current + 90.days,
        mls_number: "M212234",
        initial_agent_valuation: 185000,
        initial_client_valuation: 250000,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "D'Fantis"),
      status: 2,
      client_type: "Buyer",
      lead_type: LeadType.find_by(name: "Referral - From Database"),
      min_price_range: 200000,
      max_price_range: 300000,
      timeframe: 1,
      buyer_area_of_interest: "Madison/Guilford",
      buyer_prequalified: true,
      prequalification_amount: 350000,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.zone.now - 24.minutes,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M212234",
        bedrooms: 3,
        bathrooms: 2,
        sq_feet: 2500,
        lot_size: 2,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Hagan"),
      status: 3,
      lead_type: LeadType.find_by(name: "Referral - From Database"),
      client_type: "Buyer",
      min_price_range: 200000,
      max_price_range: 300000,
      timeframe: 1,
      buyer_area_of_interest: "Shoreline between Waterford and RI",
      buyer_prequalified: true,
      prequalification_amount: 350000,
      state: "claimed",
      contacted_status: 3,
      initial_status_when_created: 0,
      incoming_lead_at: Time.current - 10.hours,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M212235",
        bedrooms: 3,
        bathrooms: 2,
        sq_feet: 2500,
        lot_size: 2,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Sturm"),
      status: 3,
      client_type: "Seller",
      lead_type: LeadType.find_by(name: "Real Estate Profile"),
      lead_source: LeadSource.find_by(name: "Realtor.com"),
      timeframe: 0,
      amount_owed: 200000.00,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.current - 60.days,
      properties_attributes: [
        list_price: 800000,
        transaction_type: "Seller",
        property_type: 0,
        commission_type: "Percentage",
        commission_percentage: 3.00,
        original_list_date_at: Time.current - 60.days,
        original_list_price: 800000,
        listing_expires_at: Time.current + 120.days,
        mls_number: "M2342337",
        initial_agent_valuation: 750000,
        initial_client_valuation: 850000,
        address_attributes: {
          street: "43 Franklin Pierce Way",
          city: "West Hartford",
          state: "CT",
          zip: "03404"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Dowsett"),
      status: 3,
      client_type: "Seller",
      lead_type: LeadType.find_by(name: "Referral - From Database"),
      timeframe: 0,
      amount_owed: 170000.00,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.current - 70.days,
      properties_attributes: [
        list_price: 190000,
        transaction_type: "Seller",
        property_type: 0,
        commission_type: "Percentage",
        commission_percentage: 3.00,
        original_list_date_at: Time.current - 60.days,
        original_list_price: 200000,
        listing_expires_at: Time.current + 180.days,
        mls_number: "M212236",
        initial_agent_valuation: 185000,
        initial_client_valuation: 250000,
        address_attributes: {
          street: "99 Main Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Hobbs"),
      status: 4,
      lead_type: LeadType.find_by(name: "Referral - From Database"),
      client_type: "Buyer",
      min_price_range: 200000,
      max_price_range: 400000,
      timeframe: 2,
      buyer_area_of_interest: "Madison/Guilford",
      buyer_prequalified: true,
      prequalification_amount: 400000,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.zone.now - 10.minutes,
      properties_attributes: [
        list_price: 500000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M11112",
        bedrooms: 5,
        bathrooms: 3,
        sq_feet: 5000,
        lot_size: 2,
        address_attributes: {
          street: "29 Little Meadow Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Solo"),
      contact: Contact.find_by(last_name: "Hogan"),
      status: 4,
      lead_type: LeadType.find_by(name: "Referral - From Database"),
      client_type: "Buyer",
      min_price_range: 200000,
      max_price_range: 400000,
      timeframe: 2,
      buyer_area_of_interest: "Madison/Guilford",
      buyer_prequalified: true,
      prequalification_amount: 400000,
      state: "claimed",
      initial_status_when_created: 0,
      contacted_status: 3,
      incoming_lead_at: Time.zone.now - 10.minutes,
      properties_attributes: [
        list_price: 500000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M11113",
        bedrooms: 5,
        bathrooms: 3,
        sq_feet: 5000,
        lot_size: 2,
        address_attributes: {
          street: "29 Little Meadow Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Johnson"),
      status: 6,
      lead_type: LeadType.find_by(name: "Referral - From Database"),
      client_type: "Buyer",
      min_price_range: 250000,
      max_price_range: 300000,
      timeframe: 1,
      buyer_area_of_interest: "Madison/Guilford",
      buyer_prequalified: false,
      state: "claimed",
      contacted_status: 1,
      stage_lost: 0,
      initial_status_when_created: 0,
      incoming_lead_at: Time.zone.now - 8.minutes,
    )
    create_lead(
      user: User.find_by(last_name: "Smith"),
      contact: Contact.find_by(last_name: "Mouse"),
      status: 7,
      client_type: "Buyer",
      lead_type: LeadType.find_by(name: "Real Estate Profile"),
      lead_source: LeadSource.find_by(name: "Realtor.com"),
      min_price_range: 100000,
      max_price_range: 300000,
      timeframe: 1,
      buyer_area_of_interest: "Disney",
      buyer_prequalified: true,
      prequalification_amount: 150000,
      state: "claimed",
      contacted_status: 0,
      initial_status_when_created: 0,
      incoming_lead_at: Time.zone.now - 19.minutes,
      properties_attributes: [
        list_price: 300000,
        transaction_type: "Buyer",
        property_type: 0,
        mls_number: "M212239",
        bedrooms: 4,
        bathrooms: 2.5,
        sq_feet: 4500,
        lot_size: 2,
        address_attributes: {
          street: "79 Lake Street",
          city: "Guilford",
          state: "CT",
          zip: "06437"
        }
      ]
    )
  end
end

def add_tasks
  puts "  * Tasks...\n"
  Task.transaction do
    create_task subject: "Send Birthday Card",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current + 2.days,
                completed: false,
                taskable_id: Contact.find_by(last_name: "Wiltsie").id,
                taskable_type: "Contact"
    create_task subject: "Follow up on Lead",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current + 3.days,
                completed: false,
                taskable_id: Contact.find_by(last_name: "Lozar").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Check on Client Contract",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current + 3.days,
                completed: false,
                taskable_id: Contact.find_by(last_name: "Sturm").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Help Buyer",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at: Time.current,
                created_at: Time.current - 15.days,
                completed: true,
                completed_by: User.find_by(last_name: "Smith"),
                completed_at: Time.current - 1.day,
                taskable_id: Contact.find_by(last_name: "D'Fantis").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Pull MLS Paperwork",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current + 2.days,
                completed: false,
                taskable_id: Contact.find_by(last_name: "Boring").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Prepare for Showing - 59 Winthrop",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current + 3.days,
                completed: false,
                taskable_id: Contact.find_by(last_name: "Boring").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Write up Buyer Agreement",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current - 10.days,
                completed: true,
                completed_by: User.find_by(last_name: "Smith"),
                completed_at: Time.current - 1.day,
                created_at: Time.current - 25.days,
                taskable_id: Contact.find_by(last_name: "Boring").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Set up initial meeting",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current - 3.days,
                created_at: Time.current - 25.days,
                completed: true,
                completed_by: User.find_by(last_name: "Smith"),
                completed_at: Time.current - 1.day,
                taskable_id: Contact.find_by(last_name: "Boring").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Complete Final Walkthru Checklist",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current - 2.days,
                completed: false,
                taskable_id: Contact.find_by(last_name: "Dowsett").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Draft Contracts",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current - 25.days,
                completed_at: Time.current - 25.days,
                created_at: Time.current - 25.days,
                completed: true,
                completed_by: User.find_by(last_name: "Smith"),
                taskable_id: Contact.find_by(last_name: "Dowsett").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Arrange Photographs",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Smith"),
                due_date_at:  Time.current - 2.days,
                completed_at: Time.current - 1.day,
                created_at: Time.current - 5.days,
                completed: true,
                completed_by: User.find_by(last_name: "Smith"),
                taskable_id: Contact.find_by(last_name: "D'Fantis").leads.first.id,
                taskable_type: "Lead"
    create_task subject: "Research MLS info",
                user: User.find_by(last_name: "Jones"),
                assigned_to: User.find_by(last_name: "Jones"),
                due_date_at:  Time.current - 3.days,
                created_at: Time.current - 25.days,
                completed: true,
                completed_by: User.find_by(last_name: "Jones"),
                completed_at: Time.current - 1.day,
                taskable_id: Contact.find_by(last_name: "Boring").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Order Closing Gift",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Jones"),
                due_date_at:  Time.current - 2.days,
                completed: false,
                taskable_id: Contact.find_by(last_name: "Dowsett").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Setup Closing Meeting",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Jones"),
                due_date_at:  Time.current - 25.days,
                completed_at: Time.current - 25.days,
                created_at: Time.current - 25.days,
                completed: true,
                completed_by: User.find_by(last_name: "Jones"),
                taskable_id: Contact.find_by(last_name: "Dowsett").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Arrange Walkthru",
                user: User.find_by(last_name: "Smith"),
                assigned_to: User.find_by(last_name: "Jones"),
                due_date_at:  Time.current - 2.days,
                completed_at: Time.current - 1.day,
                created_at: Time.current - 5.days,
                completed: true,
                completed_by: User.find_by(last_name: "Jones"),
                taskable_id: Contact.find_by(last_name: "D'Fantis").leads.first.id,
                taskable_type: "Lead"

    create_task subject: "Set up initial meeting",
                user: User.find_by(last_name: "Solo"),
                assigned_to: User.find_by(last_name: "Solo"),
                due_date_at:  Time.current - 3.days,
                created_at: Time.current - 25.days,
                completed: true,
                completed_by: User.find_by(last_name: "Solo"),
                completed_at: Time.current - 1.day,
                taskable_id: Contact.find_by(last_name: "Sayes").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Complete Final Walkthru Checklist",
                user: User.find_by(last_name: "Solo"),
                assigned_to: User.find_by(last_name: "Solo"),
                due_date_at:  Time.current - 2.days,
                completed: false,
                taskable_id: Contact.find_by(last_name: "Hogan").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Draft Contracts",
                user: User.find_by(last_name: "Solo"),
                assigned_to: User.find_by(last_name: "Solo"),
                due_date_at:  Time.current - 25.days,
                completed_at: Time.current - 25.days,
                created_at: Time.current - 25.days,
                completed: true,
                completed_by: User.find_by(last_name: "Solo"),
                taskable_id: Contact.find_by(last_name: "Mooney").leads.last.id,
                taskable_type: "Lead"
    create_task subject: "Arrange Photographs",
                user: User.find_by(last_name: "Solo"),
                assigned_to: User.find_by(last_name: "Solo"),
                due_date_at:  Time.current - 2.days,
                completed_at: Time.current - 1.day,
                created_at: Time.current - 5.days,
                completed: true,
                completed_by: User.find_by(last_name: "Solo"),
                taskable_id: Contact.find_by(last_name: "Mooney").leads.first.id,
                taskable_type: "Lead"
  end
end

def add_contracts
  puts "  * Contracts...\n"
  Contract.transaction do
    create_contract(
      lead: Lead.find_by(name: "Miriam Hobbs (Buyer)"),
      property: Property.find_by(mls_number: "M11112"),
      offer_price: 400000,
      closing_price: 395000,
      offer_accepted_date_at: Time.current - 30.days,
      closing_date_at: Time.current - 10.days,
      status: "closed",
      commission_type: "Fee",
      commission_flat_fee: 7000,
      commission_fee_buyer_side: 7000,
      commission_fee_total: 14000,
      referral_fee_type: "Fee",
      referral_fee_flat_fee: 250,
      additional_fees: 100,
      offer_deadline_at: Time.current - 25.days,
      seller: "Mr and Mrs Benny Bitner",
      seller_agent: "Barb Boyle"
    )
    create_contract(
      lead: Lead.find_by(name: "Blair Sturm - 43 Franklin Pierce Way West Hartford (Seller)"),
      property: Property.find_by(mls_number: "M2342337"),
      offer_price: 200000,
      closing_price: 195000,
      offer_accepted_date_at: Time.current - 30.days,
      closing_date_at: Time.current - 10.days,
      status: "pending_contingencies",
      commission_type: "Fee",
      commission_flat_fee: 4100,
      commission_fee_buyer_side: 5900,
      commission_fee_total: 10000,
      referral_fee_type: "Fee",
      referral_fee_flat_fee: 250,
      additional_fees: 100,
      offer_deadline_at: Time.current - 25.days,
      buyer: "Mr and Mrs Abe Stewart",
      buyer_agent: "Barb Boyle"
    )
    create_contract(
      lead: Lead.find_by(name: "Stuart Dowsett - 99 Main Street Guilford (Seller)"),
      property: Property.find_by(mls_number: "M212236"),
      offer_price: 400000,
      closing_price: 395000,
      offer_accepted_date_at: Time.current - 30.days,
      closing_date_at: Time.current - 10.days,
      status: "pending_contingencies",
      commission_type: "Fee",
      commission_flat_fee: 6000,
      commission_fee_buyer_side: 6000,
      commission_fee_total: 12000,
      referral_fee_type: "Fee",
      referral_fee_flat_fee: 250,
      additional_fees: 100,
      offer_deadline_at: Time.current - 25.days,
      buyer: "Mr and Mrs Abe Stewart",
      buyer_agent: "Sally Summers"
    )
    create_contract(
      lead: Lead.find_by(name: "Cullen Hagan (Buyer)"),
      property: Property.find_by(mls_number: "M212235"),
      offer_price: 400000,
      closing_price: 395000,
      offer_accepted_date_at: Time.current - 30.days,
      closing_date_at: Time.current - 10.days,
      status: "pending_contingencies",
      commission_type: "Percentage",
      commission_rate: 3,
      commission_percentage_buyer_side: 3,
      commission_percentage_total: 6,
      referral_fee_type: "Fee",
      referral_fee_flat_fee: 250,
      additional_fees: 100,
      offer_deadline_at: Time.current - 25.days,
      seller: "Mr and Mrs Abe Stewart",
      seller_agent: "Sally Summers"
    )
    create_contract(
      lead: Lead.find_by(name: "Missy Hogan (Buyer)"),
      property: Property.find_by(mls_number: "M11113"),
      offer_price: 400000,
      closing_price: 395000,
      offer_accepted_date_at: Time.current - 30.days,
      closing_date_at: Time.current - 10.days,
      status: "pending_contingencies",
      commission_type: "Percentage",
      commission_rate: 2.5,
      commission_percentage_buyer_side: 2.5,
      commission_percentage_total: 5,
      referral_fee_type: "Fee",
      referral_fee_flat_fee: 250,
      additional_fees: 100,
      offer_deadline_at: Time.current - 25.days,
      seller: "Mr and Mrs Abe Stewart",
      seller_agent: "Sally Summers"
    )
  end
end

def add_lead_groups
  puts "  * Lead Groups...\n"
  LeadGroup.transaction do
    lead_group = LeadGroup.create!(
      owner: User.first,
      users: User.all.to_a,
      name: "Miami Realtors."
    )
    john = User.where(email: "john@example.com").first
    john.lead_setting.forward_to_group << lead_group
    john.lead_setting.broadcast_to_group << lead_group
    john.lead_setting.broadcast_after_minutes = 5
    john.lead_setting.save!
  end
end

def add_email_campaigns
  puts "  * Email Campaigns...\n"
  EmailCampaign.transaction do
    create_email_campaign(
      color_scheme: "Remax",
      custom_message: "Hope everyone has a wonderful new year!",
      display_custom_message: true,
      email_status: "draft",
      subject: "Market Update",
      title: "Jan 2016 Market Report"
    )
  end
end

def create_plan(options={})
  Plan.create! options
end

def create_user(options={})
  puts "    - Creating user..."
  user_attributes = { password: "welcome5" }
  attributes = user_attributes.merge options
  user = User.create! attributes
  user.lead_setting.broadcast_lead_to_group = true
  user.lead_setting.forward_lead_to_group = true
  user.lead_setting.save!
  user.team_owned = Team.create!
  user
end

def create_checkout(options={})
  Checkout.create! options
end

def create_subscription(options={})
  Subscription.create! options
end

def create_contact(options={})
  user = User.find_by(last_name: "Smith")
  contact_attributes = { created_by_user: user, user: user }
  attributes = contact_attributes.merge options
  contact = Contact.create! attributes
  contact.save!
  contact
end

def create_goal(options={})
  user = User.find_by(last_name: "Smith")
  goal_attributes = { user: user }
  attributes = goal_attributes.merge options
  Goal.create! attributes
end

def create_contact_activity(options={})
  user = User.find_by(last_name: "Smith")
  contact_activity_attributes = { user: user }
  attributes = contact_activity_attributes.merge options
  ContactActivity.create! attributes
end

def create_lead(options={})
  user = User.find_by(last_name: "Smith")
  client_attributes = { user: user, created_by_user: user }
  attributes = client_attributes.merge options
  Lead.create! attributes
end

def create_task(options={})
  user = User.find_by(last_name: "Smith")
  task_attributes = { user: user }
  attributes = task_attributes.merge options
  Task.create! attributes
end

def create_email_campaign(options={})
  user = User.find_by(last_name: "Smith")
  email_campaign_attributes = { user: user }
  attributes = email_campaign_attributes.merge options
  EmailCampaign.create!(attributes)
end

def create_teammate(options={})
  user = User.find_by(last_name: "Smith")
  teammate_attributes = { user: user }
  attributes = teammate_attributes.merge options
  Teammate.create!(attributes)
end

def create_contract(options={})
  contract_attributes = {}
  attributes = contract_attributes.merge options
  Contract.create! attributes
end

def add_john_jane_as_teammates
  john = User.find_by(email: "john@example.com")
  jane = User.find_by(email: "jane@example.com")

  john.team_owned_by_user.users << jane
  jane.team_owned_by_user

  teammate = Teammate.where(team_id: john.team_owned.id, user_id: jane.id).first

  teammate.confirm_teammates
end

def add_contacts_from_yaml
  puts "  * Contacts...\n"
  puts "    - Loading contacts from YAML files..."
  puts "    - dir=sample/contacts/load rake db:data:load_dir"
  system "dir=sample/contacts/load rake db:data:load_dir"
  puts "    - Updating user references..."
  Contact.transaction do
    Contact.where(user_id: 5).update_all(
      user_id: User.find_by(email: "john@example.com").id,
      created_by_user_id: User.find_by(email: "john@example.com").id
    )
    Contact.where(user_id: 6).update_all(
      user_id: User.find_by(email: "jane@example.com").id,
      created_by_user_id: User.find_by(email: "jane@example.com").id
    )
    Contact.where(user_id: 7).update_all(
      user_id: User.find_by(email: "samsolo@example.com").id,
      created_by_user_id: User.find_by(email: "samsolo@example.com").id
    )
  end
end
