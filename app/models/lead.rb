# == Schema Information
#
# Table name: leads
#
#  additional_fees                        :decimal(, )
#  amount_owed                            :decimal(, )
#  attempted_contact_at                   :datetime
#  buyer_area_of_interest                 :string
#  buyer_prequalified                     :boolean
#  claimed                                :boolean
#  client_type                            :string
#  contact_id                             :integer
#  contacted_status                       :integer          default(0)
#  created_at                             :datetime
#  created_by_user_id                     :integer
#  displayed_additional_fees              :decimal(, )
#  displayed_broker_commission_custom     :boolean          default(FALSE)
#  displayed_broker_commission_fee        :decimal(, )
#  displayed_broker_commission_percentage :decimal(, )
#  displayed_broker_commission_type       :string
#  displayed_broker_franchise_fee         :decimal(, )
#  displayed_broker_has_franchise_fee     :boolean          default(FALSE), not null
#  displayed_closing_date_at              :datetime
#  displayed_commission_fee               :decimal(, )
#  displayed_commission_rate              :decimal(, )
#  displayed_commission_type              :string
#  displayed_gross_commission             :decimal(, )
#  displayed_net_commission               :decimal(, )
#  displayed_price                        :decimal(, )
#  displayed_referral_fee                 :decimal(, )
#  displayed_referral_percentage          :decimal(, )
#  displayed_referral_type                :string
#  first_email_attempted_id               :integer
#  follow_up_at                           :datetime
#  id                                     :integer          not null, primary key
#  import_source_id                       :integer
#  import_source_type                     :string
#  incoming_lead_at                       :datetime
#  incoming_lead_price                    :integer          default(0)
#  incomplete_tasks_count                 :integer          default(0)
#  initial_status_when_created            :integer
#  junk_reason                            :text
#  last_broadcast_at                      :datetime
#  last_follow_up_at                      :datetime
#  lead_followup_reminder_attempted       :boolean          default(FALSE)
#  lead_followup_reminder_time            :datetime
#  lead_source_id                         :integer
#  lead_source_old                        :string
#  lead_type_id                           :integer
#  lead_type_old                          :string
#  long_term_prospect_remind_me_at        :datetime
#  lost_date_at                           :datetime
#  max_price_range                        :decimal(, )
#  min_price_range                        :decimal(, )
#  name                                   :string
#  next_action_id                         :integer
#  notes                                  :text
#  original_list_date_at                  :datetime
#  original_list_price                    :decimal(, )
#  pause_date_at                          :datetime
#  prequalification_amount                :decimal(, )
#  property_type                          :integer
#  reason_for_long_term_prospect          :string
#  reason_for_loss                        :string
#  reason_for_pause                       :string
#  referral_fee_flat_fee                  :decimal(, )
#  referral_fee_rate                      :decimal(, )
#  referral_fee_type                      :string
#  referral_fees                          :decimal(, )
#  referring_contact_id                   :integer
#  rental                                 :boolean
#  snoozed_at                             :datetime
#  snoozed_by_id                          :integer
#  snoozed_until                          :datetime
#  stage                                  :integer
#  stage_lost                             :integer
#  stage_paused                           :integer
#  state                                  :string
#  status                                 :integer
#  time_before_attempted_contact          :decimal(, )
#  timeframe                              :integer
#  unpause_date_at                        :datetime
#  updated_at                             :datetime
#  user_id                                :integer
#
# Indexes
#
#  index_leads_on_client_type                              (client_type)
#  index_leads_on_contact_id                               (contact_id)
#  index_leads_on_contacted_status                         (contacted_status)
#  index_leads_on_created_by_user_id                       (created_by_user_id)
#  index_leads_on_first_email_attempted_id                 (first_email_attempted_id)
#  index_leads_on_import_source_type_and_import_source_id  (import_source_type,import_source_id)
#  index_leads_on_lead_source_id                           (lead_source_id)
#  index_leads_on_lead_type_id                             (lead_type_id)
#  index_leads_on_next_action_id                           (next_action_id)
#  index_leads_on_property_type                            (property_type)
#  index_leads_on_referring_contact_id                     (referring_contact_id)
#  index_leads_on_snoozed_by_id                            (snoozed_by_id)
#  index_leads_on_stage                                    (stage)
#  index_leads_on_stage_lost                               (stage_lost)
#  index_leads_on_stage_paused                             (stage_paused)
#  index_leads_on_state                                    (state)
#  index_leads_on_status                                   (status)
#  index_leads_on_user_id                                  (user_id)
#

class Lead < ActiveRecord::Base

  include RecentActivity

  attr_accessor :trackable_activity, :activate_contact

  belongs_to :created_by_user, class_name: "User", inverse_of: :leads_created
  belongs_to :contact
  belongs_to :import_source, polymorphic: true
  belongs_to :lead_source
  belongs_to :lead_type
  belongs_to :next_action, class_name: "Task", inverse_of: :next_action_lead
  belongs_to :referring_contact, class_name: "Contact", inverse_of: :referrals
  belongs_to :snoozed_by, class_name: "User"
  belongs_to :user
  has_many :tasks, as: :taskable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :contact_activities, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :properties, inverse_of: :lead, dependent: :destroy
  has_many :showings, dependent: :destroy
  has_many :incomplete_tasks, -> { not_completed.order("due_date_at asc") }, class_name: "Task", as: :taskable

  accepts_nested_attributes_for :contact
  accepts_nested_attributes_for :contracts, allow_destroy: true
  accepts_nested_attributes_for :properties, :contact, allow_destroy: true

  validates :contact, presence: true

  after_initialize :set_trackable_activity
  before_create :mark_properties_for_removal
  before_create :init_last_broadcast_at
  before_create :set_initial_status_when_created
  before_save :update_contract_status
  before_save :update_contract_referral_fee
  before_save :set_time_before_attempted_contact
  before_save :unlink_lead_source, unless: :lead_type_is_from_social_media_or_real_estate?
  after_save :set_number_of_closed_leads_ytd, :reset_trackable_activity

  before_validation :set_user_for_contact, on: :create, if: -> { self.contact.try :new_record? }

  CLIENT_CONTACT_STATUSES = [
    ["Not Contacted",            0],
    ["Attempted Contact",        1],
    ["Awaiting Client Response", 2],
    ["Contacted",                3]
  ].freeze
  LEAD_SOURCES = ["trulia", "zillow", "realtor"].freeze
  LEAD_TYPES = [
    ["Referral",           0],
    ["Internet",           1],
    ["Listed Property",    2],
    ["Marketing Campaign", 3]
  ].freeze
  LIVE_STATUS_IDS = [0, 1, 2, 3].freeze
  PROPERTY_TYPES = [
    ["Single Family",     0],
    ["Multi-family",      1],
    ["Condo",             2],
    ["Apartment",         3],
    ["Commercial/Office", 4],
    ["Land",              5]
  ].freeze
  REBROADCAST_TIMES = 3
  SNOOZE_TIMES = [
    ["for 1 hour",        1],
    ["for 2 hours",       2],
    ["for 4 hours",       4],
    ["until tomorrow",   24],
    ["for 2 days",       48],
    ["until next week", 168]
  ].freeze
  JUNK_REASON = [
    ["Spam",            1],
    ["Fake Name",       2],
    ["Bad Lead",        3],
    ["Another Agent",   4]
  ].freeze
  STATUS_HEADERS = {
    1 => "Prospects",
    2 => "Active Clients",
    3 => "Pendings"
  }.freeze
  STATUSES = [
    ["Lead",               0],
    ["Prospect",           1],
    ["Active",             2],
    ["Pending",            3],
    ["Closed",             4],
    ["Paused",             5],
    ["Not Converted",      6],
    ["Junk",               7],
    ["Long Term Prospect", 8]
  ].freeze
  TIMEFRAMES = [
    ["0-3 months",  0],
    ["3-6 months",  1],
    ["6-12 months", 2],
    ["1-2 years",   3],
    ["2+ years",    4]
  ].freeze
  TIMEFRAMES_IN_INTEGERS = [3, 6, 12, 18, 24].freeze

  scope :active_clients, -> { client_status.where("status in (2, 3)") }
  scope :active_and_closed_clients, -> { client_status.where("status in (2, 3, 4)") }
  scope :buyers, -> { where("client_type = 'Buyer'") }
  scope :client_current_pipeline_status, -> { client_status.where("status in (1, 2, 3)") }
  scope :client_all_status, -> { client_status.where("status IN (1, 2, 3, 4, 5) or (status = 6 AND stage_lost != 0 )") }
  scope :client_not_converted_status, -> { client_status.where("status = 6 AND stage_lost != 0 ") }
  scope :client_long_term_prospect_status, -> { client_status.where("status = 8 AND stage_lost != 0 ") }
  scope :client_long_term_prospect_due, -> { where("status = 8 AND long_term_prospect_remind_me_at < ?", Time.current.beginning_of_day) }
  scope :client_status, -> { where("status != 0") }
  scope :clients_active_and_closed, -> { where("status in (1, 2, 3, 4, 5)") }
  scope :clients_active_and_closed_excluding_prosects_and_paused, -> { where("status in (2, 3, 4)") }
  scope :closed_buyer_leads_after_date, ->(date) { where("displayed_closing_date_at >= ? AND status = 4 AND client_type = 'Buyer'", date) }
  scope :closed_leads_after_date, ->(date) { where("displayed_closing_date_at >= ? AND status = 4", date) }
  scope :closed_seller_leads_after_date, ->(date) { where("displayed_closing_date_at >= ? AND status = 4 AND client_type = 'Seller'", date) }
  scope :contact_not_made, -> { where("contacted_status <> 3 ") }
  scope :contacted_leads_with_dates, -> { where("contacted_status <> 0 AND incoming_lead_at is not null AND attempted_contact_at is not null") }
  scope :created_after_date, ->(date) { where("created_at >= ?", date) }
  scope :initially_leads, -> { where("initial_status_when_created = 0") }
  scope :house_listing_after_date, ->(date) { where("original_list_date_at >= ?", date) }
  scope :lead_source_count, ->(source_id) { where("lead_source_id = ?", source_id).count }
  scope :lead_status, -> { where("status = 0") }
  scope :leads_attempted_contact, -> { lead_status.where("contacted_status = 1") }
  scope :leads_awaiting_client_response, -> { lead_status.where("contacted_status = 2") }
  scope :leads_by_status, ->(status) { where("status = ?", status) }
  scope :leads_claimed_by_other_user, ->(user) { where("(leads.created_by_user_id = ?) AND (leads.user_id != ?)", user, user) }
  scope :leads_contacted, -> { lead_status.where("contacted_status = 3 ") }
  scope :leads_not_converted_status, -> { where("status = 6 AND stage_lost::int = 0 ") }
  scope :leads_junk_status, -> { where("status = 7") }
  scope :leads_not_converted_or_junk_status, -> { where("status = 7 OR (status = 6 AND stage_lost::int = 0)") }
  scope :leads_not_contacted, -> { lead_status.where("contacted_status = 0 ") }
  scope :leads_responsible_for, ->(user) { lead_status.where("(leads.user_id = ?) OR (leads.created_by_user_id = ? AND leads.state != 'claimed')", user, user) }
  scope :leads_unclaimed, -> { lead_status.where("leads.state != 'claimed'") }
  scope :listings, -> { where("client_type = 'Seller'") }
  scope :live_leads, -> { where(status: LIVE_STATUS_IDS) }
  scope :long_term_prospect_clients, -> { client_status.where("status = 8") }
  scope :needing_action, ->(user) do
    query = "(created_by_user_id = ? AND state != 'claimed')"\
            " OR (user_id = ? AND contacted_status IN (?))"
    where(query, user, user, [0, 3])
  end
  scope :not_snoozed, -> { where("snoozed_until < ? OR snoozed_until is null", Time.current) }
  scope :open_clients, -> { client_status.where("status in (1, 2, 3, 5)") }
  scope :open_clients_and_leads, -> { client_status.where("status in (0, 1, 2, 3, 5)") }
  scope :open_leads_and_clients, -> { where("status in (0,1,2,3,4,5)") }
  scope :owned_by_team_member, ->(owner_ids) { where("leads.user_id IN  (?)", owner_ids) }
  scope :owned_or_created_by_user, ->(user) { where("(leads.user_id = ?) OR (leads.created_by_user_id = ?)", user, user) }
  scope :search_name, ->(search_term) { joins(:contact).where("contacts.first_name ILIKE :search_term OR contacts.last_name ILIKE :search_term", search_term: "%#{search_term.downcase}%") }
  scope :sellers, -> { where("client_type = 'Seller'") }
  scope :unclaimed_leads_responsible_for, ->(user) { lead_status.where("(leads.user_id = ? AND leads.state != 'claimed') OR (leads.created_by_user_id = ? AND leads.state != 'claimed')", user, user) }
  scope :updatable_for_commission_data, -> { where(displayed_broker_commission_custom: false).where.not(status: [4, 6, 7]) }
  scope :pure_leads, -> { where(status: [0, 7]) }
  scope :year_to_date_leads, -> { where(displayed_closing_date_at: Time.current.beginning_of_year..Time.current) }
  scope :last_year_leads, -> { where(displayed_closing_date_at: Time.current.last_year.beginning_of_year..Time.current.last_year.end_of_year) }
  scope :past_12_months_leads, -> { where(displayed_closing_date_at: (Time.current - 1.year)..Time.current) }

  state_machine :state, initial: :new_lead do
    state :claimed
    state :referred
    state :broadcast
    state :re_broadcast
    state :manually_forward
    state :unclaimed
    state :failed

    event :claim! do
      transition all => :claimed
    end

    event :unclaim! do
      transition claimed: :unclaimed
    end

    event :refer! do
      transition new_lead: :referred
    end

    event :broadcast! do
      transition all => :broadcast
    end

    event :re_broadcast! do
      transition all => :re_broadcast
    end

    event :fail! do
      transition all: :failed
    end

    event :manually_forward! do
      transition all: :manually_forward
    end

    before_transition all => :claimed, :do => :send_claim_sms_notification
    after_transition all => :unclaimed, :do => :send_unclaimed_notification
  end

  include PublicActivity::Model
  include ActivityWatcher

  tracked(
    owner: proc { |controller, _| controller.current_user if controller },
    recipient: proc { |_, lead| lead },
    params: {
      changes: :activity_parameters_changes,
      name: :name
    },
    on: {
      update: proc do |model, _|
        model.trackable_activity &&
          model.savable_activity?(model.activity_parameters_changes)
      end
    }
  )

  recent_activities_for(
    self: {
      attributes: [
        :additional_fees,
        :amount_owed,
        :buyer_area_of_interest,
        :buyer_prequalified,
        :claimed,
        :contacted_status,
        :incoming_lead_at,
        :lost_date_at,
        :max_price_range,
        :min_price_range,
        :name,
        :notes,
        :original_list_date_at,
        :original_list_price,
        :pause_date_at,
        :prequalification_amount,
        :property_type,
        :reason_for_loss,
        :reason_for_pause,
        :referral_fee_flat_fee,
        :referral_fee_rate,
        :referral_fee_type,
        :referring_contact_id,
        :rental,
        :state,
        :status,
        :timeframe
      ]
    }
  )

  extend_recent_activities_for(
    comments: {
      condition: ->(contact) do
        {
          recipient_id: contact.id,
          recipient_type: contact.class.to_s,
          key: ["comment.create", "comment.destroy"]
        }
      end
    },
    contact_activities: {
      condition: ->(lead) do
        {
          recipient_id: lead.contact.id,
          recipient_type: lead.contact.class.to_s,
          associable_id: lead.id,
          associable_type: lead.class.to_s,
          key: [
            "contact_activity.create",
            "contact_activity.destroy",
            "contact_activity.update"
          ]
        }
      end
    },
    contracts: {
      condition: ->(contact) do
        {
          recipient_id: contact.id,
          recipient_type: contact.class.to_s,
          key: ["contract.create", "contract.destroy", "contract.update"]
        }
      end
    },
    properties: {
      condition: ->(contact) do
        {
          recipient_id: contact.id,
          recipient_type: contact.class.to_s,
          key: ["property.create", "property.destroy", "property.update"]
        }
      end
    },
    tasks: {
      condition: ->(contact) do
        {
          recipient_id: contact.id,
          recipient_type: contact.class.to_s,
          key: ["task.complete", "task.create", "task.destroy", "task.update"]
        }
      end
    }
  )

  def self.comments_or_tasks_updated_in_range(starttime, endtime)
    self.includes(:comments, :tasks).
      where(
        "(comments.created_at BETWEEN ? AND ?) OR
        (tasks.completed_at BETWEEN ? AND ?) OR
        (tasks.created_at BETWEEN ? AND ?)",
        starttime, endtime, starttime, endtime, starttime, endtime
      ).references(:comments, :tasks)
  end

  def self.incoming_at_during_range(start_time:, end_time:)
    self.where("incoming_lead_at BETWEEN ? AND ?", start_time, end_time)
  end

  def self.incoming_at_during_ytd
    self.incoming_at_during_range(start_time: Time.current.beginning_of_year, end_time: Time.current)
  end

  def self.incoming_at_during_past_12_months
    self.incoming_at_during_range(start_time: Time.current - 12.months, end_time: Time.current)
  end

  def self.incoming_at_during_last_year
    self.incoming_at_during_range(start_time: (Time.current - 1.year).beginning_of_year, end_time: (Time.current - 1.year).end_of_year)
  end

  def set_trackable_activity
    self.trackable_activity = true
  end

  def reset_trackable_activity
    set_trackable_activity
  end

  def state_to_s
    state = self.state
    if state == "new_lead"
      "Unclaimed"
    elsif state == "claimed"
      "Claimed"
    elsif state == "referred"
      "Unclaimed"
    elsif state == "broadcast"
      "Unclaimed"
    elsif state == "re_broadcast"
      "Unclaimed"
    else
      "Unclaimed"
    end
  end

  def snoozed?
    snoozed_until.present? && snoozed_until > Time.current
  end

  def buyer_properties
    properties.buyer_properties
  end

  def initials_of_name
    [first_name[0], last_name[0]].map(&:presence).compact.join
  end

  def elapsed_time_before_lead_contacted
    received_at = incoming_lead_at
    if received_at && attempted_contact_at
      (attempted_contact_at - received_at)
    end
  end

  def set_time_before_attempted_contact
    if self.attempted_contact_at && self.incoming_lead_at
      if self.attempted_contact_at > self.incoming_lead_at
        self.time_before_attempted_contact = self.attempted_contact_at - self.incoming_lead_at
      end
    end
  end

  def display_image
    if client_type == "Seller" && listing_property.property_image
      listing_property.property_image
    else
      contact.try(:display_image)
    end
  end

  def display_full_name
    contact.full_name || contact.primary_email_address ||
      contact.primary_phone_number || "Unknown"
  end

  def referral?
    lead_type_to_s == "Referral - From Database" ||
      lead_type_to_s == "Referral - From Business Network" ||
      lead_type_to_s == "Referral - From Realtor"
  end

  def lead_property
    properties.first
  end

  def initial
    contact.try(:initial)
  end

  def avatar_class
    contact.try(:avatar_class)
  end

  def listing_property
    properties.first
  end

  def listing_property_address
    listing_property.address if listing_property
  end

  def listing_address_street
    if listing_property_address
      listing_property_address.street
    end
  end

  def listing_list_price
    if listing_property && listing_property.list_price
      listing_property.list_price
    end
  end

  def listing_address_city
    listing_property_address.city if listing_property_address
  end

  def listing_address_state
    listing_property_address.state if listing_property_address
  end

  def listing_address_zip
    listing_property_address.zip if listing_property_address
  end

  def has_listing_contracts?
    listing_property.contracts.present?
  end

  def listing_contracts
    if has_listing_contracts?
      listing_property.contracts
    end
  end

  def find_next_action
    incomplete_tasks.first
  end

  def find_second_to_next_action
    if next_action
      incomplete_tasks.where("id != ?", next_action.id).first
    end
  end

  def display_next_action_subject
    if find_next_action
      find_next_action.subject
    else
      "None"
    end
  end

  def accepted_listing_contract
    contracts.accepted.first
  end

  def accepted_buyer_contract
    contracts.accepted.first
  end

  def status_to_s
    status.nil? ? "N/A" : STATUSES[status][0]
  end

  def contacted_status_to_s
    contacted_status.nil? ? "N/A" : CLIENT_CONTACT_STATUSES[contacted_status][0]
  end

  def stage_lost_to_s
    stage_lost.nil? ? "N/A" : STATUSES[stage_lost][0]
  end

  def stage_paused_to_s
    stage_paused.nil? ? "N/A" : STATUSES[stage_paused][0]
  end

  def timeframe_to_s
    timeframe.nil? ? "None" : TIMEFRAMES[timeframe][0]
  end

  def property_type_to_s
    property_type.nil? ? "None Specified" : PROPERTY_TYPES[property_type][0]
  end

  def lead_type_to_s
    lead_type_id.present? ? lead_type.name : ""
  end

  def lead_source_to_s
    lead_source_id.present? ? lead_source.name : ""
  end

  def lead_source_showable?
    lead_type_is_from_social_media_or_real_estate?
  end

  def set_user_for_contact
    self.contact.created_by_user ||= self.user
  end

  def claimed?
    self.state == "claimed"
  end

  def can_be_unclaimed?
    self.claimed?
  end

  def send_unclaimed_notification
    LeadUnclaimedNotifierService.new(self).process
  end

  def claim_new_lead(user_id)
    user = User.find(user_id)

    Lead.transaction do
      self.user = user
      self.contact.user = user
      save!
      self.claim!
    end

    if claimed?
      NewLeadProcessingMailer.delay.notify_about_lead_claimed user.id, self.id
      true
    else
      false
    end
  end

  def forward_lead_now?
    if self.state == "new_lead" && self.created_by_user &&
       self.created_by_user.lead_setting.forward_lead_to_group?
      forward_after_minutes = created_by_user.lead_setting.forward_after_minutes
      Time.current > (self.created_at + forward_after_minutes.minutes)
    else
      false
    end
  end

  def broadcast_lead_now?
    if ["new_lead", "referred"].include?(self.state) &&
       self.created_by_user &&
       self.created_by_user.lead_setting.broadcast_lead_to_group?
      lead_setting = created_by_user.lead_setting
      total_broadcast_after_minutes = lead_setting.forward_after_minutes.to_i +
                                      lead_setting.broadcast_after_minutes.to_i
      Time.current > (self.created_at + total_broadcast_after_minutes.minutes)
    else
      false
    end
  end

  def re_broadcast_lead_now?
    if ["re_broadcast", "manually_forward"].include?(self.state) &&
       self.created_by_user &&
       self.created_by_user.lead_setting.broadcast_lead_to_group?
      lead_setting = created_by_user.lead_setting
      Time.current > self.last_broadcast_at + lead_setting.broadcast_after_minutes.minutes
    else
      false
    end
  end

  def set_broadcast_state!
    lead_setting = self.created_by_user.lead_setting
    update_attribute :last_broadcast_at, Time.current
    if (self.created_at + (REBROADCAST_TIMES * lead_setting.broadcast_after_minutes.to_i).minutes) > Time.current
      re_broadcast!
    else
      broadcast!
    end
  end

  def refer_to_lead_group(lead_group_id)
    lead_group = LeadGroup.find(lead_group_id)
    ManualLeadForwardingService.new(self, lead_group).process
    self.manually_forward!
    save!
  end

  def most_recent_comment
    comments.order("created_at desc").first
  end

  def most_recent_task
    tasks.completed.order("created_at desc").first
  end

  def most_recent_contact_activity
    contact_activities.order("created_at desc").first
  end

  def most_recent_activity
    if most_recent_task.try(:completed_at) && most_recent_contact_activity.present?
      if most_recent_task.completed_at >= most_recent_contact_activity.completed_at
        most_recent_task
      else
        most_recent_contact_activity
      end
    elsif most_recent_task.present?
      most_recent_task
    elsif most_recent_contact_activity.present?
      most_recent_contact_activity
    end
  end

  def mark_as_not_converting(lead_params)
    lead_params[:stage_lost] = self.status
    lead_params[:status] = 6
    lead_params[:lost_date_at] ||= Time.current
    if lead_params[:activate_contact]
      self.contact.update!(active: true)
    end
    self.update!(lead_params)
  end

  def mark_as_paused(lead_params)
    lead_params[:stage_paused] = self.status
    lead_params[:status] = 5
    lead_params[:pause_date_at] ||= Time.current
    lead_params[:unpause_date_at] ||= 1.month.from_now
    self.update!(lead_params)
  end

  def mark_as_long_term_prospect(lead_params)
    lead_params[:status] = 8
    lead_params[:long_term_prospect_remind_me_at] ||= 1.month.from_now
    self.update!(lead_params)
  end

  def set_initial_status_when_created
    self.initial_status_when_created = self.status
  end

  def init_public_lead_details(user, created_by_user_logged_in)
    self.status           = 0
    self.contacted_status = "not_contacted"
    self.incoming_lead_at = Time.current
    self.created_by_user  = user
    if created_by_user_logged_in || user.lead_setting.forwarding_off?
      auto_claim user
    end
  end

  def notify_about_public_lead_generation(created_by_user_logged_in)
    return if created_by_user_logged_in || self.created_by_user.lead_setting.forwarding_off?

    notifier.notify

    if self.forward_lead_now?
      LeadForwardingNotifierService.new(self).process
    end
  end

  def auto_claim(user)
    self.user = user
    self.contact.user = user
    self.state = "claimed"
  end

  def set_number_of_closed_leads_ytd
    if self.user
      _user = self.user
      _user.number_of_closed_leads_YTD = _user.closed_leads_ytd.count
      _user.save
    end
  end

  def destroy_blank_buyer_properties(lead_params)
    if lead_params[:client_type] == "Buyer" && lead_params[:properties_attributes]
      lead_params[:properties_attributes].each do |properties_params_array|
        properties_params = properties_params_array[1]
        if properties_params[:address_attributes][:street].blank? &&
           properties_params[:address_attributes][:city].blank?
          properties_params[:_destroy] = "1"
        end
      end
    end
  end

  def mark_properties_for_removal
    if client_type == "Buyer"
      properties.each do |property|
        unless property.transaction_type == "Buyer" &&
               (property.address.city.present? || property.address.street.present?)
          property.mark_for_destruction
        end
      end
    elsif client_type == "Seller"
      properties.each do |property|
        property.mark_for_destruction unless property.transaction_type == "Seller"
      end
    end
  end

  def update_contract_status
    if contract = (accepted_listing_contract || accepted_buyer_contract)
      Rails.logger.info "[LEAD.update_contract_status] Updating contract status..."
      Rails.logger.info "[LEAD.update_contract_status] Changed: #{self.changed}"
      Rails.logger.info "[LEAD.update_contract_status] Status: #{status}"
      if self.changed.include?("status")
        if status == 3
          Rails.logger.info "[LEAD.update_contract_status] Update contract status to 'pending_contingencies'"
          contract.update_columns(status: "pending_contingencies", closing_price: nil)
          contract.touch
        elsif status == 4
          Rails.logger.info "[LEAD.update_contract_status] Update contract status to 'closed'"
          contract.update_columns(status: "closed", closing_price: contract.offer_price)
          contract.touch
        end
      else
        Rails.logger.info "[LEAD.update_contract_status] Status was not changed"
      end
    end
  end

  def update_contract_referral_fee
    if self.referral_fee_type == "Percentage"
      self.referral_fee_flat_fee = nil
    elsif self.referral_fee_type == "Fee"
      self.referral_fee_rate = nil
    end
    contracts.each do |contract|
      contract.update_columns(
        additional_fees: additional_fees,
        referral_fee_type: referral_fee_type,
        referral_fee_rate: referral_fee_rate,
        referral_fee_flat_fee: referral_fee_flat_fee
      )
      contract.touch
    end
  end

  def call_inboxapp(token)
    email_address = contact.primary_email_address.try(:email)
    if email_address && token
      NylasApi::Thread.new(token: token).find_by_email_address(email_address)
    end
  end

  def fetch_email_messages(token)
    email_address = contact.primary_email_address.try(:email)
    if email_address && token
      NylasApi::Message.new(token: token).find_by_email_address(email_address)
    end
  end

  # the following is for daily_lead_client_recap mailer
  def tasks_created_or_completed_since_yesterday
    tasks.
      created_or_completed_within_date_range(
        Time.current.beginning_of_day - 1.day,
        Time.current
      ).
      order("updated_at desc")
  end

  def tasks_created_since_yesterday
    tasks.created_within_date_range(Time.current.beginning_of_day - 1.day, Time.current)
  end

  def number_of_tasks_created_since_yesterday
    tasks_created_since_yesterday.count
  end

  def tasks_completed_since_yesterday
    tasks.completed_within_date_range(Time.current.beginning_of_day - 1.day, Time.current)
  end

  def number_of_tasks_completed_since_yesterday
    tasks_completed_since_yesterday.count
  end

  def comments_created_or_updated_since_yesterday
    comments.created_or_updated_within_date_range(Time.current.beginning_of_day - 1.day, Time.current)
  end

  def comments_created_since_yesterday
    comments.created_within_date_range(Time.current.beginning_of_day - 1.day, Time.current).order("created_at desc")
  end

  def number_of_comments_created_since_yesterday
    comments_created_since_yesterday.count
  end

  def comments_updated_since_yesterday
    comments.updated_within_date_range(Time.current.beginning_of_day - 1.day, Time.current)
  end

  # the following is for weekly_lead_client_recap mailer
  def tasks_created_or_completed_since_last_week
    tasks.
      created_or_completed_within_date_range(
        Time.current.beginning_of_day - 7.days,
        Time.current
      ).
      order("updated_at desc")
  end

  def tasks_created_since_last_week
    tasks.created_within_date_range(Time.current.beginning_of_day - 7.days, Time.current)
  end

  def number_of_tasks_created_since_last_week
    tasks_created_since_last_week.count
  end

  def tasks_completed_since_last_week
    tasks.completed_within_date_range(Time.current.beginning_of_day - 7.days, Time.current)
  end

  def number_of_tasks_completed_since_last_week
    tasks_completed_since_last_week.count
  end

  def comments_created_or_updated_since_last_week
    comments.created_or_updated_within_date_range(Time.current.beginning_of_day - 7.days, Time.current)
  end

  def comments_created_since_last_week
    comments.created_within_date_range(Time.current.beginning_of_day - 7.days, Time.current).order("created_at desc")
  end

  def number_of_comments_created_since_last_week
    comments_created_since_last_week.count
  end

  def comments_updated_since_last_week
    comments.updated_within_date_range(Time.current.beginning_of_day - 7.days, Time.current)
  end

  def buyer?
    client_type == "Buyer"
  end

  def listing?
    client_type == "Seller"
  end

  private

  def init_last_broadcast_at
    self.last_broadcast_at = Time.current
  end

  def send_claim_sms_notification
    LeadClaimedNotificationJob.perform_later(self.id)
  end

  def notifier
    @notifier ||= NotifierForPublicLeadGenerationService.new(self)
  end

  def lead_contract
    if client_type == "Seller"
      @contract = accepted_listing_contract
    elsif client_type == "Buyer"
      @contract = accepted_buyer_contract
    end
  end

  def initialize(*args, &block)
    super(*args, &block) # NOTE: This *must* be called, otherwise states won't get initialized
  end

  def lead_type_is_from_social_media_or_real_estate?
    ["Social Media", "Real Estate Profile"].include?(lead_type.try(:name))
  end

  def unlink_lead_source
    self.lead_source_id = nil
  end

end
