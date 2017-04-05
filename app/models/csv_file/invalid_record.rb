# == Schema Information
#
# Table name: csv_file_invalid_records
#
#  contact_errors :text
#  created_at     :datetime
#  csv_file_id    :integer
#  id             :integer          not null, primary key
#  original_row   :text
#  updated_at     :datetime
#

class CsvFile::InvalidRecord < ActiveRecord::Base
  self.table_name = 'csv_file_invalid_records'

  belongs_to :csv_file
  serialize :contact_errors, Array

  def parser
    @parser ||= ::ImportData::SmartCsvParser.new(csv_file.file.url)
  end

  def row
    @row ||= CSV.parse(original_row)[0]
  end

  def smart_row
    ::ImportData::SmartCsvRow.new(parser.headers, row)
  end
end
