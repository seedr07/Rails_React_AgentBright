# == Schema Information
#
# Table name: csv_files
#
#  created_at              :datetime
#  csv                     :string
#  id                      :integer          not null, primary key
#  import_result           :hstore           default({})
#  state                   :string
#  total_failed_records    :integer          default(0)
#  total_import_time_in_ms :string
#  total_imported_records  :integer          default(0)
#  total_parsed_records    :integer          default(0)
#  updated_at              :datetime
#  user_id                 :integer
#
# Indexes
#
#  index_csv_files_on_user_id  (user_id)
#

require 'import_data/smart_csv_parser'

class CsvFile < ActiveRecord::Base
  TwiceImportError = Class.new(StandardError)
  ReportBeforeImportError = Class.new(StandardError)

  belongs_to :user
  has_many :invalid_records, class_name: '::CsvFile::InvalidRecord', dependent: :destroy
  has_many :contacts, as: :import_source, dependent: :nullify

  mount_uploader :csv, CsvUploader

  attr_accessor :file_url

  def filename
    self[:csv]
  end

  state_machine initial: :uploaded, use_transactions: false do
    state :processing
    state :failed
    state :imported

    event :start_import! do
      transition uploaded: :processing
    end
    after_transition :uploaded => :processing,  do: :parse_data!

    event :finish_import! do
      transition processing: :imported
    end
    after_transition processing: :imported, do: :remove_errors_if_any!

    event :failed! do
      transition processing: :failed
    end
  end

  def import!(file_url=nil)
    if file_url.nil?
      file_url = csv.url
    end

    self.file_url = file_url
    raise TwiceImportError, "cannot import same file twice" unless uploaded?

    start_import!
  end

  def import_failed?
    import_result[:error].present?
  end

  def send_report!
    raise ReportBeforeImportError, 'please #import! before reporting' unless imported?
    Mailer.delay.csv_import_report(self)
  end

  def save_import_error(exception)
    import_result[:error_class] = exception.class.to_s
    import_result[:error] = exception.message
    import_result[:backtrace] = exception.backtrace
    import_result_will_change!
    save(validate: false)
  end

  def filename
    csv.file.filename
  end

  private

  def parse_data!
    # CsvParsingService.new(self).perform # => Old import logic which takes almost 1 second just to parse one row.
    ImportCsv::Contacts::ImportService.new(self).perform
  end

  def remove_errors_if_any!
    if self.import_result.present?
      self.import_result = {}
      self.save!
    end
  end

  def initialize(*args, &block)
    super(*args, &block) # NOTE: This *must* be called, otherwise states won't get initialized
  end
end
