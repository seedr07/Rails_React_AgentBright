require 'import_data'

namespace :import do
  namespace :csv do

    def import_contacts(user: nil, parser: nil)

      $stdout.puts "Importing #{parser.count} contact(s)"

      ActiveRecord::Base.transaction do
        parser.each_contact do |contact|
          $stdout.print "."
          contact.user = user
          contact.save!
        end
        $stdout.puts
      end
    end

    desc "import contacts from google csv"
    task :google_csv => :environment  do
      path = ENV['CSV']
      email = ENV['USER_EMAIL']

      import_contacts(
        user: User.find_by(email: email),
        parser: ImportData::GoogleCsvParser.new(path)
      )
    end

    desc "import contacts from google csv"
    task :top_producer_csv => :environment  do
      path = ENV['CSV']
      email = ENV['USER_EMAIL']

      import_contacts(
        user: User.find_by(email: email),
        parser: ImportData::TopProducerCsvParser.new(path)
      )
    end

    desc "import contacts from google csv using smart parser"
    task :workaround => :environment  do
      user = User.last
      cf = user.csv_files.create!

      # Staging version are limited by 200-300 records to avoid PG 10.000 record limit by Heroku for free accounts
      file_type = Rails.env.production? ? 'production' : 'staging'
      path = Rails.root.join("config/csv/google.#{file_type}.csv")

      cf.import!(path.to_s)
      cf.send_report!
    end

    desc "import all contacts from csv"
    task :all => :environment do
      user = User.first

      # Staging version are limited by 200-300 records to avoid PG 10.000 record limit by Heroku for free accounts
      file_type = Rails.env.production? ? 'production' : 'staging'

      path = Rails.root.join("config/csv/google.#{file_type}.csv")
      puts "Importing contacts from #{path}"
      import_contacts(user: user, parser: ImportData::GoogleCsvParser.new(path))

      path = Rails.root.join("config/csv/top_producer.#{file_type}.csv")
      puts "Importing contacts from #{path}"
      import_contacts(user: user, parser: ImportData::TopProducerCsvParser.new(path))
    end
  end
end