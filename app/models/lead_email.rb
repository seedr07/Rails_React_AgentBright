# == Schema Information
#
# Table name: lead_emails
#
#  created_at       :datetime
#  date             :string
#  from             :string
#  headers          :text
#  html             :text
#  id               :integer          not null, primary key
#  importing_state  :string           default("received")
#  nylas_message_id :string
#  recipient        :string
#  subject          :string
#  text             :text
#  to               :string
#  token            :string
#  updated_at       :datetime
#  user_id          :integer
#
# Indexes
#
#  index_lead_emails_on_recipient  (recipient)
#

class LeadEmail < ActiveRecord::Base

  EXCLUDED_EMAILS_FROM = %w(
    @logentries.com
    @papertrail.com
  )

  has_one :contact, as: :import_source, dependent: :nullify
  has_one :lead, as: :import_source, dependent: :nullify

  after_initialize :set_initial_importing_state

  state_machine :importing_state, initial: :received do
    state :processing
    state :imported
    state :failed
    state :parsing_error
    state :source_inactive

    event :process! do
      transition any => :processing
    end
    after_transition any => :imported, do: :transition_to_processing

    event :imported! do
      transition processing: :imported
    end
    after_transition :processing => :imported, do: :transition_to_imported

    event :source_inactive! do
      transition processing: :source_inactive
    end
    after_transition :processing => :source_inactive,  do: :transition_to_source_inactive

    event :failed! do
      transition processing: :failed
    end
    after_transition :processing => :failed, do: :transition_to_failed

    event :parsing_error! do
      transition processing: :parsing_error
    end
    after_transition :processing => :parsing_error,  do: :transition_to_parsing_error

    event :no_parser_found! do
      transition processing: :no_parser_found
    end
    after_transition :processing => :no_parser_found, do: :transition_to_no_parser_found

    event :lead_data_invalid! do
      transition processing: :lead_data_invalid
    end
    after_transition :processing => :lead_data_invalid, do: :transition_to_lead_data_invalid

  end

  def transition_to_processing
    Util.log ""
    Util.log "transitioning to processing"
    Util.log ""
  end

  def transition_to_imported
    Util.log ""
    Util.log "transitioning to imported"
    Util.log ""
    if self.nylas_message_id.nil?
      notifier.notify_about_success
      notifier.auto_respond_to_lead

      if self.lead.forward_lead_now?
        LeadForwardingNotifierService.new(self.lead).process
      end
    end
  end

  def transition_to_source_inactive
    if self.nylas_message_id.nil?
      notifier.forward_raw_email
    end
    Util.log "transitioning to source_inactive. #{self.inspect}"
  end

  def transition_to_failed
    if self.nylas_message_id.nil?
      notifier.notify_about_fail
    end
    Util.log "transitioning to parsing_failed. #{self.inspect}"
  end

  def transition_to_lead_data_invalid
    Util.log "transitioning to lead_data invalid. #{self.inspect}"
    if self.nylas_message_id.nil?
      notifier.notify_about_fail
    end
  end

  def transition_to_no_parser_found
    if self.nylas_message_id.nil?
      notifier.notify_about_fail
    end
    Util.log "no_parser_found"
  end

  def transition_to_parsing_error
    if self.nylas_message_id.nil?
      notifier.notify_about_fail
    end
    Util.log "parsing error"
  end

  scope :failed, -> { where(importing_state: :failed) }
  scope :imported, -> { where(importing_state: :imported) }

  validates :recipient, presence: true
  validates :contact, presence: true, if: :imported?

  def find_user_by_recipient!
    if self.user_id
      User.find(self.user_id) || raise("No user record was found for id #{self.user_id}")
    else
      User.find_by(ab_email_address: self.recipient) || raise("No
      user record was found for ab_email #{self.recipient}")
    end
  end

  def notifier
    @notifier ||= NotifierForContactGeneratedFromLeadService.new(self)
  end

  private

  def set_initial_importing_state
    # NOTE: state_machine gem: This method is added because after upgrading Rails to
    # 4.2. Initial state doesn't get set by default when we initialize the
    # object. This is a small hack on it. Once gem owner fixes this issue, then we
    # need to remove this logic.

    self.importing_state ||= "received"
  end

end
