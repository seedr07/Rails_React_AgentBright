require 'import_data/base_parser'
require 'import_data/top_producer_csv_row'

module ImportData
  class TopProducerCsvParser < BaseParser

    def initialize(path='./tmp/top_producer.csv')
      super
    end

    def row_class
      ::ImportData::TopProducerCsvRow
    end

    def each_contact
      each {|row| yield row.to_contact[0] }
    end
  end
end