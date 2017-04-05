require 'csv'
require 'open-uri'
require 'import_data/base_row'

module ImportData
  class BaseParser

    def row_class
      ::ImportData::BaseRow
    end

    def initialize(file_url)
      @file_url = file_url
    end

    def loaded?
      @loaded
    end

    def load_csv_data
      tmp_csv_file = fetch_remote_csv_to_local_file
      @matrix = CSV.read(tmp_csv_file.path, encoding: 'iso-8859-1:utf-8')
      @headers = @matrix.shift
      @headers.freeze
      @matrix.freeze

      @loaded = true
    end

    def fetch_remote_csv_to_local_file
      remote_csv_data = open(@file_url).read
      tmp_csv_file = Tempfile.open @file_url.gsub(/[^0-9a-z ]/i, ''), "#{Rails.root}/tmp"
      tmp_csv_file.write remote_csv_data.force_encoding("ISO-8859-1").encode("UTF-8")
      tmp_csv_file.rewind
      tmp_csv_file
    end

    def headers
      load_csv_data unless loaded?
      @headers
    end

    def matrix
      load_csv_data unless loaded?
      @matrix
    end

    def count
      matrix.size
    end

    def stats
      @stats ||= begin
        stats = {}
        headers.each.with_index do |h, i|
          stats[h] = 0
          matrix.size.times do |x|
            stats[h] += 1 if matrix[x][i].present?
          end
        end
        stats
      end
    end

    def indices(*titles)
      titles.map{|title| headers.index(title)}
    end

    def slice(*titles)
      matrix.map{|row| indices(*titles).map{|i| row[i] }}
    end

    def headers_like(*names)
      headers.select{|header| names.any?{|name| header =~ /#{name}/}}
    end

    def appearance(*titles, n:titles.size)
      slice(*titles).select{|x| x.sum{|a| a.present? ? 1 : 0 } == n }
    end

    include Enumerable

    def each
      matrix.each do |row|
        yield row_class.new(headers, row)
      end
    end
  end
end
