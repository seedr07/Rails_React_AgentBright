desc "shows the status of the market reports for the past three months"

task :scraper_summary => :environment do
  puts "\n" + title("CTMLS SCRAPER REPORT")

  last_month = Time.current.beginning_of_month - 1.month

  months = [last_month, last_month - 1.month, last_month - 2.months]

  months.each do |month|
    puts title("#{month.strftime("%B %Y")}")

    market_locations.each do |location_type|
      location_report(location_type, month)
    end
  end
end

def market_locations
  ["MarketZip", "MarketCity", "MarketCounty"]
end

def location_report(location_type, month)
  puts "\n" + header(location_type.underscore.humanize)
  reports = MarketReport.where(location_type: location_type, report_date_at: month)
  puts "Number of #{location_type.underscore.humanize(capitalize: false).pluralize}: #{location_type.constantize.count}"
  reports_table(reports)
end

def reports_table(reports)
  puts "Number of reports: #{reports.count}"
  puts "#{spacing(45, "REPORT")} #{spacing(7, "DATA")} #{spacing(7, "ZERO")} #{spacing(7, "NIL")}"
  MarketReport::REPORT_TYPES.each do |_key, report|
    field = report[:column]
    zero_reports = reports.where(field => 0).count
    nil_reports = reports.where(field => nil).count
    has_data_reports = reports.where("#{field.to_s} > ?", 0).count
    puts "#{spacing(45, field)} #{spacing(7, has_data_reports)} #{spacing(7, zero_reports)} #{spacing(7, nil_reports)}"
  end
end

def spacing(distance, field)
  spaces = distance - (field.to_s.length)
  "#{' ' * spaces}#{field}"
end

def title(message)
  "\n#{'=' * message.length}\n#{message}\n#{'=' * message.length}\n\n"
end

def header(message)
  "#{message}\n#{'-' * message.length}\n"
end
