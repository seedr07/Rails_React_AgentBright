def execute(cmd)
  puts cmd
  system cmd
end

namespace :market_data do

  desc "Delete existing market data from database"
  task delete: :environment do
    delete_market_data_from_database
  end

  desc "Import market data from /db/load/"
  task import: :environment do
    delete_market_data_from_database
    load_data
    market_data_count
  end

  desc "Load data to database from /db/load/"
  task load_data: :environment do
    load_data
  end

  desc "Export market data from database and store in /db/load"
  task export: :environment do
    delete_dump_folder
    dump_data
    delete_files_in_load_folder
    move_files_from_dump_to_load_folder
    delete_dump_folder
    market_data_count
  end

  desc "Dump data from database to /db/dump/"
  task dump: :environment do
    dump_data
  end

  desc "Remove old files in /db/load/"
  task delete_files_in_load_folder: :environment do
    delete_files_in_load_folder
  end

  desc "Copy exported files to /db/load/"
  task move_files_from_dump_to_load_folder: :environment do
    move_files_from_dump_to_load_folder
  end

  desc "Delete /db/dump/"
  task delete_dump_folder: :environment do
    delete_dump_folder
  end

end

def delete_market_data_from_database
  market_data_count
  puts "\nWiping market data from the current database..."
  MarketReport.transaction do
    MarketReport.delete_all
    MarketState.delete_all
    MarketCity.delete_all
    MarketCounty.delete_all
    MarketZip.delete_all
  end

  market_data_count
end

def load_data
  puts "\nLoading data from yaml files in db/load folder into current database..."
  execute "dir=load rake db:data:load_dir"
end

def dump_data
  puts "\nDumping data from current database..."
  execute "dir=dump rake db:data:dump_dir"
end

def delete_files_in_load_folder
  puts "\nDeleting old yaml files to make room for the new ones..."
  execute "rm db/load/market_cities.yml"
  execute "rm db/load/market_counties.yml"
  execute "rm db/load/market_reports.yml"
  execute "rm db/load/market_states.yml"
  execute "rm db/load/market_zips.yml"
end

def move_files_from_dump_to_load_folder
  puts "\nCopying new exported files to the db/load folder..."
  execute "cp db/dump/market_cities.yml db/load"
  execute "cp db/dump/market_counties.yml db/load"
  execute "cp db/dump/market_reports.yml db/load"
  execute "cp db/dump/market_states.yml db/load"
  execute "cp db/dump/market_zips.yml db/load"
end

def delete_dump_folder
  puts "\nDeleting the folder db/dump..."
  execute "rm -R db/dump"
end

def market_data_count
  puts "\nChecking current market data rows in the database..."
  puts "Market Zips: #{MarketZip.count}"
  puts "Market Cities: #{MarketCity.count}"
  puts "Market Counties: #{MarketCounty.count}"
  puts "Market States: #{MarketState.count}"
  puts "Market Reports: #{MarketReport.count}"
end
