require "csv"

desc "Import locations from CSV files"

task import_locations_from_csv: :environment do
  MarketState.transaction do
    import_market_states
    import_market_counties
    import_market_cities
    import_market_zip_codes

    add_market_report_sample_data
  end
end

def import_market_states
  puts "\nAdding states..."
  MarketState.create!(name: "Connecticut", abbreviation: "CT")
end

def import_market_counties
  counties_csv = Rails.root.join("config/csv/locations/counties.csv")
  puts "\nAdding counties..."

  CSV.foreach(counties_csv, headers: true) do |row|
    county = row.to_hash

    name = strip_county(county["name"])
    market_state = MarketState.find_by(abbreviation: county["market_state"])

    if name.present? && market_state.present?
      puts "  * #{name}"
      MarketCounty.create!(
        name: name,
        market_state: market_state
      )
    else
      puts "  * skipping - name: #{name}, state: #{market_state}"
    end
  end
end

def import_market_cities
  cities_csv = Rails.root.join("config/csv/locations/cities.csv")
  puts "\nAdding cities..."

  CSV.foreach(cities_csv, headers: true) do |row|
    city = row.to_hash

    name = city["primary_city"].strip
    market_county = MarketCounty.find_by(name: strip_county(city["county"]))
    market_state = MarketState.find_by(abbreviation: city["state"])

    if name.present? && market_state.present? && market_county.present?
      puts "  * #{name}"
      MarketCity.create!(
        name: name,
        market_county: market_county,
        market_state: market_state
      )
    else
      puts "  * skipping - name: #{name}, county: #{market_county}, state: #{market_state}"
    end
  end
end

def import_market_zip_codes
  zip_codes_csv = Rails.root.join("config/csv/locations/zip_codes.csv")
  puts "\nAdding zip codes..."

  CSV.foreach(zip_codes_csv, headers: true) do |row|
    zip_code = row.to_hash

    name = zip_code["zip"].strip
    market_city = MarketCity.find_by(name: zip_code["city"])
    market_county = MarketCounty.find_by(name: strip_county(zip_code["county"]))
    market_state = MarketState.find_by(abbreviation: zip_code["state"])

    if name.present? && market_state.present? && market_county.present?
      puts "  * #{name}"
      MarketZip.create!(
        name: name,
        market_city: market_city,
        market_county: market_county,
        market_state: market_state
      )
    else
      puts "  * skipping - name: #{name}, city: #{market_city}, county: #{market_county}, state: #{market_state}"
    end
  end
end

def add_market_report_sample_data
  puts "Adding market reports..."
  MarketReport.create(
    location: MarketZip.find_by(name: "06426"),
    report_date_at: Time.parse("01/2016"),
    average_list_price: 285_000,
    median_list_price: 282_000,
    average_days_on_market_listings: 87,
    number_of_new_listings: 5,
    number_of_sales: 8,
    average_sales_price: 243_833,
    median_sales_price: 228_000,
    average_days_on_market_sold: 97,
    original_vs_sales_price_ratio_avg_for_sale: 94,
    number_of_listings: 35
  )
  MarketReport.create(
    location: MarketZip.find_by(name: "06371"),
    report_date_at: Time.parse("01/2016"),
    average_list_price: 313_000,
    median_list_price: 399_000,
    average_days_on_market_listings: 108,
    number_of_new_listings: 2,
    number_of_sales: 4,
    average_sales_price: 298_000,
    median_sales_price: 346_000,
    average_days_on_market_sold: 131,
    original_vs_sales_price_ratio_avg_for_sale: 89,
    number_of_listings: 35
  )
end

def strip_county(county)
  county.slice!("County")
  county.strip
end
