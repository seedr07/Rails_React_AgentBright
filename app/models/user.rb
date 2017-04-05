# == Schema Information
#
# Table name: users
#
#  ab_email_address                               :string           not null
#  account_marked_inactive_at                     :datetime
#  address                                        :string
#  agent_percentage_split                         :decimal(, )
#  annual_broker_fees_paid                        :decimal(, )
#  authentication_token                           :string
#  avatar_color                                   :integer          default(0)
#  billing_address                                :string           default("")
#  billing_address_2                              :string           default("")
#  billing_city                                   :string           default("")
#  billing_country                                :string           default("")
#  billing_email_address                          :string           default("")
#  billing_first_name                             :string           default("")
#  billing_last_name                              :string           default("")
#  billing_organization                           :string           default("")
#  billing_state                                  :string           default("")
#  billing_zip_code                               :string           default("")
#  broker_fee_alternative                         :boolean          default(FALSE)
#  broker_fee_alternative_split                   :decimal(, )
#  broker_fee_per_transaction                     :decimal(, )
#  broker_percentage_split                        :decimal(, )
#  city                                           :string
#  commission_split_type                          :string
#  company                                        :string
#  company_website                                :string
#  contacts_count                                 :integer          default(0)
#  contacts_database_storage                      :string
#  country                                        :string
#  created_at                                     :datetime
#  current_sign_in_at                             :datetime
#  current_sign_in_ip                             :string
#  dly_calls_counter                              :integer          default(0)
#  dly_notes_counter                              :integer          default(0)
#  dly_visits_counter                             :integer          default(0)
#  email                                          :string           default(""), not null
#  email_campaign_track_clicks                    :boolean          default(TRUE)
#  email_campaign_track_opens                     :boolean          default(TRUE)
#  email_signature                                :text
#  email_signature_status                         :boolean
#  encrypted_password                             :string           default(""), not null
#  fax_number                                     :string
#  first_name                                     :string
#  franchise_fee                                  :boolean          default(FALSE), not null
#  franchise_fee_per_transaction                  :decimal(, )
#  id                                             :integer          not null, primary key
#  initial_setup                                  :boolean          default(FALSE)
#  last_cursor                                    :string
#  last_name                                      :string
#  last_sign_in_at                                :datetime
#  last_sign_in_ip                                :string
#  lead_form_key                                  :string
#  mobile_number                                  :string
#  monthly_broker_fees_paid                       :decimal(, )
#  name                                           :string
#  nilas_account_status                           :string
#  nilas_calendar_setting_id                      :string
#  nilas_trial_status_set_at                      :datetime
#  number_of_closed_leads_YTD                     :integer          default(0)
#  nylas_account_id                               :string
#  nylas_connected_email_account                  :string
#  nylas_sync_status                              :string
#  nylas_token                                    :string
#  office_number                                  :string
#  per_transaction_fee_capped                     :boolean          default(FALSE)
#  personal_website                               :string
#  profile_pic                                    :string
#  real_estate_experience                         :string
#  remember_created_at                            :datetime
#  reset_password_sent_at                         :datetime
#  reset_password_token                           :string
#  show_beta_features                             :boolean          default(FALSE), not null
#  show_narrow_main_nav_bar                       :boolean          default(FALSE)
#  sign_in_count                                  :integer          default(0), not null
#  state                                          :string
#  stripe_customer_id                             :string
#  subscribed                                     :boolean          default(FALSE)
#  subscription_account_status                    :integer          default(1)
#  subscription_account_status_marked_inactive_at :datetime
#  super_admin                                    :boolean          default(FALSE)
#  team_group_id                                  :integer
#  team_id                                        :integer
#  team_name                                      :string
#  time_zone                                      :string
#  transaction_fee_cap                            :integer
#  twitter_secret                                 :string
#  twitter_token                                  :string
#  ungraded_contacts_count                        :integer          default(0)
#  updated_at                                     :datetime
#  wkly_calls_counter                             :integer          default(0)
#  wkly_notes_counter                             :integer          default(0)
#  wkly_visits_counter                            :integer          default(0)
#  zip                                            :string
#
# Indexes
#
#  index_users_on_email                          (email) UNIQUE
#  index_users_on_last_cursor                    (last_cursor)
#  index_users_on_nylas_connected_email_account  (nylas_connected_email_account)
#  index_users_on_nylas_token                    (nylas_token)
#  index_users_on_reset_password_token           (reset_password_token) UNIQUE
#  index_users_on_stripe_customer_id             (stripe_customer_id)
#  index_users_on_team_group_id                  (team_group_id)
#

class User < ActiveRecord::Base

  KEY_FORMAT_REG = /[a-zA-Z0-9+\/]+/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise(
    :async,
    :database_authenticatable,
    :omniauthable,
    :recoverable,
    :registerable,
    :rememberable,
    :trackable,
    :validatable,
    omniauth_providers: [:facebook, :twitter, :linkedin, :google_oauth2]
  )
  acts_as_tagger

  belongs_to :team_group
  has_and_belongs_to_many :lead_groups
  has_one :lead_setting, dependent: :destroy
  has_one :profile_image, as: :attachable, class_name: "Image", dependent: :destroy
  has_one :team_owned, class_name: "Team", inverse_of: :owner, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :contact_activities, dependent: :destroy
  has_many :contact_email_addresses, through: :contacts, source: :email_addresses
  has_many :contact_phone_numbers, through: :contacts, source: :phone_numbers
  has_many :contacts, dependent: :destroy
  has_many :contacts_created, class_name: "Contact", inverse_of: :created_by_user, foreign_key: "created_by_user_id", dependent: :nullify
  has_many :csv_files, dependent: :destroy
  has_many :cursors, dependent: :destroy
  has_many :email_campaigns, dependent: :destroy
  has_many :email_messages, dependent: :destroy
  has_many :failed_api_imports, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :inbox_messages, dependent: :destroy
  has_many :lead_groups_owned, class_name: "LeadGroup", inverse_of: :owner, dependent: :destroy
  has_many :leads, dependent: :destroy
  has_many :leads_created, class_name: "Lead", inverse_of: :created_by_user, foreign_key: "created_by_user_id", dependent: :nullify
  has_many :properties, dependent: :nullify
  has_many :mandrill_messages, dependent: :nullify
  has_many :print_campaigns, dependent: :destroy
  has_many :print_campaign_messages, dependent: :nullify
  has_many :subscriptions, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :tasks_assigned, class_name: "Task", inverse_of: :assigned_to, foreign_key: "assigned_to_id", dependent: :nullify
  has_many :tasks_completed, class_name: "Task", inverse_of: :completed_by, foreign_key: "completed_by_id", dependent: :nullify
  has_many :teammates, dependent: :destroy
  has_many :teams, through: :teammates, dependent: :destroy

  accepts_nested_attributes_for :profile_image

  scope :for_daily_overall_recap, -> (user_ids=nil) do
    joins(:lead_setting).where(
      lead_settings: {
        user_id: user_ids || self.all.map(&:id),
        daily_overall_recap: true
      }
    )
  end

  scope :for_receive_next_action_reminder_sms, -> (user_ids=nil) do
    joins(:lead_setting).where(
      lead_settings: {
        user_id: user_ids || self.all.map(&:id),
        next_action_reminder_sms: true
      }
    )
  end

  before_validation :set_user_name, on: :create
  before_validation :build_ab_email_address, on: :create
  before_validation :build_lead_form_key, on: :create
  before_validation :set_time_zone, on: :create
  validates :first_name, :last_name, :ab_email_address, presence: true
  validates :lead_form_key, presence: true, uniqueness: true, format: { with: /\A#{User::KEY_FORMAT_REG}\Z/ }
  before_save :ensure_authentication_token_is_present
  before_save :set_name
  after_create :build_lead_setting_for_user

  after_create :set_avatar_background_color

  delegate :plan, to: :subscription, allow_nil: true
  delegate :scheduled_for_cancellation_on, to: :subscription, allow_nil: true

  REAL_ESTATE_EXPERIENCE = {
    "50001" => "I'm brand new",
    "50002" => "0-2 years",
    "50003" => "2-5 years",
    "50004" => "5-10 years",
    "50005" => "10-20 years",
    "50006" => "20+ years",
  }.freeze

  CONTACTS_DATABASE_STORAGE = {
    "50001" => "Another real estate CRM",
    "50002" => "Google / Gmail",
    "50003" => "Outlook",
    "50004" => "My smartphone",
    "50005" => "Excel spreadsheet",
    "50006" => "Other",
    "50007" => "On paper or not stored digitally",
  }.freeze

  # URL_REGEX = /\b((?:https?:\/\/|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/?)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s\`!()\[\]{};:\'\".,<>?«»“”‘’]))/i
  # NOTE: This regex comes from
  # http://daringfireball.net/2010/07/improved_regex_for_matching_urls
  # by @gruber, which is preferred source for this.

  BASIC_URL_REGEX = /\A[A-Za-z0-9\.\/:]+[A-Za-z0-9_-]+\.+[A-Za-z0-9.\/%&=\?_:;-]+\z/i

  NYLAS_ACCOUNT_SYNC_STATUSES = {
    "account.invalid" => "Invalid",
    "account.running" => "Running",
    "account.connected" => "Connected",
    "account.stopped" => "Stopped"
  }


  validates(
    :personal_website,
    format: { with: BASIC_URL_REGEX, message: "Please enter valid URL." },
    unless: Proc.new { |user| user.personal_website.blank? }
  )
  validates(
    :company_website,
    format: { with: BASIC_URL_REGEX, message: "Please enter valid URL." },
    unless: Proc.new { |user| user.company_website.blank? }
  )

  validates :mobile_number, :office_number, :fax_number, length: { minimum: 10, allow_blank: true }
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.us_zones.collect(&:name) }

  attr_accessor :invite_code

  def self.with_active_subscription
    includes(subscriptions: :plan, team_group: { subscription: :plan }).
      select(&:has_active_subscription?)
  end

  def self.subscriber_count
    Subscription.active.joins(team_group: :users).count +
      Subscription.active.includes(:team_group).where(team_groups: { id: nil }).count
  end

  def inactive_subscription
    if has_active_subscription?
      nil
    else
      most_recently_deactivated_subscription
    end
  end

  def create_subscription(plan:, stripe_id:, card_last_four_digits:, card_type:, card_expires_on:, trial_ends_at:)
    subscriptions.create(
      plan: plan,
      stripe_id: stripe_id,
      card_last_four_digits: card_last_four_digits,
      card_type: card_type,
      card_expires_on: card_expires_on,
      trial_ends_at: trial_ends_at
    )
  end

  def has_active_subscription?
    subscription.present?
  end

  def has_access_to?(feature)
    subscription.present? && subscription.has_access_to?(feature)
  end

  def subscribed_at
    subscription.try(:created_at)
  end

  def credit_card
    customer = stripe_customer

    if customer
      customer.cards.detect { |card| card.id == customer.default_card }
    end
  end

  def plan_name
    plan.try(:name)
  end

  def team_group_owner?
    team_group && team_group.owner?(self)
  end

  def subscription
    [personal_subscription, team_group_subscription].compact.detect(&:active?)
  end

  def eligible_for_annual_upgrade?
    plan.present? && plan.has_annual_plan?
  end

  def annualized_payment
    plan.annualized_payment
  end

  def discounted_annual_payment
    plan.discounted_annual_payment
  end

  def annual_plan_sku
    plan.annual_plan_sku
  end

  def deactivate_personal_subscription
    if personal_subscription
      Cancellation.new(subscription: personal_subscription).cancel.now
    end
  end

  def has_credit_card?
    stripe_customer_id.present?
  end

  def in_trial_without_card?
    has_active_subscription? &&
      !subscription.has_credit_card? &&
      subscription.in_trial?
  end

  def trial_ends_at
    if has_active_subscription?
      subscription.trial_ends_at
    end
  end

  def has_connection_with(provider)
    auth = self.authorizations.find_by(provider: provider)
    if auth.present?
      auth.token.present?
    else
      false
    end
  end

  def is_administrator?
    role.casecmp == "Administrator"
  end

  def is_not_administrator?
    !is_administrator?
  end

  def has_no_team_members?
    false
  end

  def full_name
    [first_name, last_name].map(&:presence).compact.join(" ")
  end

  def initials
    [first_name[0], last_name[0]].map(&:presence).compact.join
  end

  def initial
    full_name[0]
  end

  def set_avatar_background_color
    self.update!(avatar_color: Random.rand(12))
  end

  def avatar_class
    if self.avatar_color
      "abg#{self.avatar_color}"
    else
      "abg0"
    end
  end

  def next_notes
    (contacts.relationships.next_contacts_to_write_notes(Time.zone.today).
      time_since_last_activity(5.days).includes(:addresses).order("grade asc").
      order("next_note_at asc") - next_calls).
      first(number_of_activities_until_goal("Note"))
  end

  def next_calls
    contacts.relationships.next_contacts_to_call(Time.zone.today).
      time_since_last_activity(5.days).order("grade asc").
      order("next_call_at asc").limit(number_of_activities_until_goal("Call"))
  end

  def next_visits
    ((contacts.relationships.next_contacts_to_visit(Time.zone.today).
      time_since_last_activity(5.days).order("grade asc").
      order("next_visit_at asc") - next_calls) - next_notes).
      first(number_of_activities_until_goal("Visit"))
  end

  def last_goal
    self.goals.last
  end

  def closed_leads_ytd
    self.leads.closed_leads_after_date(Time.zone.now.beginning_of_year)
  end

  def closed_team_leads_ytd
    team_leads.closed_leads_after_date(Time.zone.now.beginning_of_year)
  end

  def closed_leads_forecast_to_end_of_year
    self.leads.closed_leads_after_date(Time.zone.now.end_of_year)
  end

  def over_transaction_fee_cap?
    if per_transaction_fee_capped && transaction_fee_cap
      number_of_closed_leads_ytd >= transaction_fee_cap
    else
      false
    end
  end

  def broker_split
    if agent_percentage_split
      100 - agent_percentage_split
    end
  end

  def open_leads_count
    self.leads.lead_status.count
  end

  def not_contacted_leads_count
    Lead.leads_responsible_for(self).lead_status.leads_not_contacted.count
  end

  def display_image
    if profile_image
      profile_image
    end
  end

  def profile_image_url
    if profile_image
      profile_image.file.url
    else
      "https://placehold.it/180"
    end
  end

  def build_ab_email_address
    self.ab_email_address ||= generate_ab_email_address
  end

  def build_lead_form_key
    self.lead_form_key ||= generate_lead_form_key
  end

  def contacts_with_grade_count
    self.contacts.active.where("grade is not null").size
  end

  MIN_CONTACTS_FOR_INITIAL_SETUP = 5

  def mark_initial_setup_done!
    if self.contacts_with_grade_count >= MIN_CONTACTS_FOR_INITIAL_SETUP && self.goals_entered
      self.update_attributes!(initial_setup: true)
    end
  end

  def goals_entered
    if last_goal.nil?
      false
    elsif last_goal.note_required_wkly.nil? || last_goal.calls_required_wkly.nil? || last_goal.visits_required_wkly.nil?
      false
    elsif last_goal.note_required_wkly < 1
      false
    else
      true
    end
  end

  def set_user_name
    self.name ||= full_name
  end

  def set_name
    if first_name || last_name
      self[:name] = self.full_name
    end
  end

  def number_of_contacts
    active_contacts_count
  end

  def active_contacts_count
    contacts.active.count
  end

  def graded_contacts_count
    contacts.graded.active.count
  end

  def live_leads_count
    leads.live_leads.size
  end

  def average_new_lead_response_time
    contacted_leads = leads.contacted_leads_with_dates
    contacted_leads_count = contacted_leads.count
    total_time = 0
    contacted_leads.each do |lead|
      total_time = total_time + (lead.attempted_contact_at - lead.incoming_lead_at)
    end
    if contacted_leads_count > 0
      total_time / contacted_leads_count
    end
  end

  def average_new_lead_response_time_past_week
    contacted_leads = leads.contacted_leads_with_dates.created_after_date(Time.zone.now - 7.days)
    contacted_leads_count = contacted_leads.count
    total_time = 0
    contacted_leads.each do |lead|
      total_time = total_time + (lead.attempted_contact_at - lead.incoming_lead_at)
    end
    if contacted_leads_count > 0
      total_time / contacted_leads_count
    end
  end

  # total number of clients that are prospect,active or pending
  def number_of_active_and_prospect_clients
    leads.client_current_pipeline_status.count
  end

  # total number of clients that are active or pending
  def number_of_active_clients
    leads.active_clients.count
  end

  # Total number of listings that are active or pending
  def number_of_active_listings
    leads.active_clients.listings.count
  end

  # Total number of buyers that are active or pending
  def number_of_active_buyers
    leads.active_clients.buyers.count
  end

  # Average list price for active, pending and closed with original listing date wthin last year
  def avg_list_price_last_12_months
    one_year_ago = Time.zone.now - 1.year
    active_and_closed_listings_with_price =
      leads.active_and_closed_clients.house_listing_after_date(one_year_ago).
      listings.where("original_list_price is not null")

    num_of_listings = active_and_closed_listings_with_price.count

    total_active_and_closed_listings_price = active_and_closed_listings_with_price.sum(:original_list_price)

    if num_of_listings > 0
      total_active_and_closed_listings_price / num_of_listings
    else
      0
    end
  end

  # Average sales price for closed listings within last 12 months
  def avg_sale_price_last_12_months
    one_year_ago = Time.zone.now - 1.year
    avg_sale_price = leads.closed_leads_after_date(one_year_ago).average(:displayed_price)
    if avg_sale_price
      avg_sale_price
    else
      0
    end
  end

  # Average days on market report for listings that have been closed
  def avg_days_on_market
    one_year_ago = Time.zone.now - 1.year
    Util.log "one_year_ago is this: #{one_year_ago}"
    closed_ytd =
      leads.closed_leads_after_date(one_year_ago).
      where("original_list_date_at is not null AND displayed_closing_date_at is not null")
    if closed_ytd.count > 0
      total_time = 0
      closed_ytd.each do |lead|
        total_time = total_time + (lead.displayed_closing_date_at.to_date - lead.original_list_date_at.to_date)
      end
      total_time / closed_ytd.count
    else
      0
    end
  end

  # average days for listings closed within last 365 days
  def avg_days_to_closing
    one_year_ago = Time.zone.now - 1.year
    closed_ytd = leads.closed_leads_after_date(one_year_ago).
                 where("original_list_date_at is not null AND displayed_closing_date_at is not null")
    if closed_ytd.count > 0
      total_time = 0
      closed_ytd.each do |lead|
        total_time = total_time + (lead.displayed_closing_date_at.to_date - lead.original_list_date_at.to_date)
      end
      total_time / closed_ytd.count
    else
      0
    end
  end

  # TODO - displayed commission rate no longer exists
  # def avg_commission_rate
  #   closed_ytd = leads.closed_leads_after_date(Time.zone.now - 1.year).
  #                  listings.where("displayed_commission_rate is not null")
  #   if closed_ytd.count > 0
  #     closed_ytd.average(:displayed_commission_rate)
  #   else
  #     0
  #   end
  # end

  # Earned YTD Gross Commssion for an Agent

  def gross_commission_earned_YTD
    total_gross_commission_earned_ytd = 0
    closed_leads_ytd.each do |closed_lead|
      total_gross_commission_earned_ytd = total_gross_commission_earned_ytd + closed_lead.displayed_gross_commission
    end
    total_gross_commission_earned_ytd
  end

  def avg_lead_field_value(field)
    closed_ytd = leads.closed_leads_after_date(Time.zone.now - 1.year).where("#{field} is not null")
    if closed_ytd.count > 0
      closed_ytd.average(field)
    else
      0
    end
  end

  # Average Gross Commission for all Clients (buyers and sellers) within last year
  def avg_gross_commission
    self.avg_lead_field_value(:displayed_gross_commission)
  end

  # Average (Net)Commission for all Clients (buyers and sellers) within last year
  def avg_net_commission
    self.avg_lead_field_value(:displayed_net_commission)
  end

  # Sale to List Price

  def sale_to_list_price_cumulative
    one_year_ago = Time.zone.now - 1.year

    closed_ytd =
      leads.closed_leads_after_date(one_year_ago).
      where("original_list_price is not null AND displayed_price is not null")
    if closed_ytd.count > 0
      closed_ytd_original_list_price_total = 0
      closed_ytd_displayed_price_total = 0
      closed_ytd.each do |lead|
        closed_ytd_original_list_price_total = (closed_ytd_original_list_price_total + lead.original_list_price)
        closed_ytd_displayed_price_total = (closed_ytd_displayed_price_total + lead.displayed_price)
      end
      if closed_ytd_original_list_price_total > 0
        (closed_ytd_displayed_price_total / closed_ytd_original_list_price_total) * 100
      end
    else
      0
    end
  end

  # Pipeline Reporting Methods for displaying the Agents Client Stats

  def display_pipeline_status_total_house_value(status)
    leads.leads_by_status(status).sum(:displayed_price).to_i
  end

  def display_pipeline_status_total_net_commission(status)
    leads.leads_by_status(status).sum(:displayed_net_commission).to_i
  end

  def display_pipeline_status_count(status)
    leads.leads_by_status(status).count
  end

  def pipeline_current_closed_ytd_house_value
    closed_leads_ytd.sum(:displayed_price).to_i
  end

  def display_pipeline_closed_ytd_net_commission
    closed_leads_ytd.sum(:displayed_net_commission).to_i
  end

  def display_pipeline_closed_ytd_gross_commission
    closed_leads_ytd.sum(:displayed_gross_commission).to_i
  end

  def display_pipeline_closed_ytd_count
    closed_leads_ytd.count.to_i
  end

  def display_pipeline_closed_last_12_months
    one_year_ago = Time.zone.now - 1.year
    leads.closed_leads_after_date(one_year_ago).sum(:displayed_price).to_i
  end

  # Pipeline Reporting Methods for displaying the Agents Client Stats

  def belongs_to_team?
    user_has_teammates?
  end

  def display_projected_commission
    leads.client_current_pipeline_status.sum(:displayed_net_commission).to_i
  end

  def number_of_activities_until_goal(activity_type)
    if goals_entered
      activities = (
        if activity_type == "Call"
          goals.last.daily_calls_goal - contact_activities.completed_today("Call").count
        elsif activity_type == "Note"
          goals.last.daily_notes_goal - contact_activities.completed_today("Note").count
        elsif activity_type == "Visit"
          goals.last.daily_visits_goal - contact_activities.completed_today("Visit").count
        else
          0
        end
      )
      if activities > 0
        activities
      else
        0
      end
    else
      5
    end
  end

  def build_lead_setting_for_user
    if self.lead_setting.blank?
      self.build_lead_setting
      save!
    end
  end

  def team_owned_by_user
    self.team_owned || self.team_owned = Team.create!
  end

  def team_member_ids
    member_ids = if self.team_owned
                   self.team_owned.approved_teammates.pluck(:id) << self.id
                 else
                   [self.id]
                 end
    member_ids.uniq
  end

  def team_member_ids_except_self
    if self.team_owned
      member_ids = self.team_owned.approved_teammates.map(&:id)
      member_ids.uniq unless member_ids.nil?
    end
  end

  def user_has_teammates?
    team_member_ids.count > 1
  end

  def team_leads
    Lead.owned_by_team_member(self.team_member_ids)
  end

  def team_tasks
    Task.owned_by_team_member(self.team_member_ids)
  end

  def team_tasks_assigned
    Task.assigned_to_team_member(self.team_member_ids)
  end

  def team_tasks_assigned_to_other_teammates
    Task.assigned_to_team_member(self.team_member_ids_except_self)
  end

  def has_nylas_token?
    nylas_token.present?
  end

  def lead_groups_owned_or_part_of
    (lead_groups + lead_groups_owned).flatten.uniq
  end

  def in_lead_group?
    !lead_groups_owned_or_part_of.empty?
  end

  def send_daily_overall_recap_email
    DailyRecapMailer.overall(self.id).deliver_now
  end

  def self.send_all_daily_overall_recap_emails
    User.for_daily_overall_recap.find_each(&:send_daily_overall_recap_email)
  end

  def self.send_all_next_action_reminder_sms_messages
    User.for_receive_next_action_reminder_sms.find_each do |user|
      if user.clients_without_next_action.present?
        user.send_next_action_reminder_sms
      end
    end
  end

  def send_next_action_reminder_sms
    payload = "AGENTBRIGHT: #{first_name}, you have "\
              "#{TextHelper.pluralize(clients_without_next_action.count, 'client', plural: 'clients')} "\
              "that don't have next actions set. Update them at "\
              "#{Rails.application.secrets.host}/#status-board"
    Util.log("Sending SMS: #{payload}")
    SmsService.new.dispatch(
      to: mobile_number,
      payload: payload
    )
  end

  def stripe_send_cancel_stripe_request_email
    StripeMailer.stripe_send_cancel_stripe_request_email(self.id).deliver_now
  end

  def leads_received_in_last_week
    Lead.owned_or_created_by_user(self).initially_leads.created_after_date(Time.zone.now - 7.days).count
  end

  def leads_referred_in_last_week
    Lead.leads_claimed_by_other_user(self).initially_leads.created_after_date(Time.zone.now - 7.days).count
  end

  def leads_referred_or_contact_attempted_in_past_week
    self.leads.initially_leads.created_after_date(Time.zone.now - 7.days).
      where("contacted_status <> 0 ").count + self.leads_referred_in_last_week
  end

  def open_leads_received_in_last_week
    # owner or created by user by not claimed or processed
    Lead.leads_responsible_for(self).lead_status.created_after_date(Time.zone.now - 7.days).count
  end

  def promoted_leads_received_in_last_week
    leads.initially_leads.clients_active_and_closed.created_after_date(Time.zone.now - 7.days).count
  end

  def junk_leads_received_in_last_week
    leads.initially_leads.leads_junk_status.created_after_date(Time.zone.now - 7.days).count
  end

  def not_converted_leads_received_in_last_week
    leads.initially_leads.leads_not_converted_status.created_after_date(Time.zone.now - 7.days).count
  end

  def rate_of_leads_contacted_in_under_30_minutes_in_past_week
    if leads_received_in_last_week > 0
      leads.created_after_date(Time.zone.now - 7.days).
        where("leads.contacted_status <> 0 AND leads.time_before_attempted_contact <= ?", 30.minutes).
        count / leads_received_in_last_week.to_f
    end
  end

  def activities_grouped_for_date(date)
    activities = activities_for_date(date)
    activities.group_by do |activity|
      I18n.l(activity.created_at.change(min: 0), format: :hours_mins_mer).upcase
    end
  end

  def activities_for_date(date)
    PublicActivity::Activity.
      where(
        "created_at >= ? AND created_at <= ?",
        date.beginning_of_day,
        date.end_of_day
      ).
      where(owner_id: team_member_ids).
      order("created_at ASC")
  end

  def in_quiet_hours?
    if quiet_hours_on?
      now = Time.zone.now.seconds_since_midnight
      seconds_per_hour = 3600.seconds
      start_time = lead_setting.quiet_hours_start * seconds_per_hour
      end_time = lead_setting.quiet_hours_end * seconds_per_hour

      result = between_start_and_end_hour?(now, start_time, end_time)
      Util.log(
        "start: #{lead_setting.quiet_hours_start}, end: "\
        "#{lead_setting.quiet_hours_end}, in_quiet_hours? #{result}"
      )
      result
    end
  end

  def quiet_hours_on?
    lead_setting.quiet_hours == true
  end

  def between_start_and_end_hour?(now, start_time, end_time)
    if start_time > end_time
      true unless now.between?(end_time, start_time)
    elsif end_time < start_time
      now.between?(start_time, end_time)
    end
  end

  def update_billing_information(first_name, last_name, email, organization,
                                 address, address_2, city, state, zip_code,
                                 country)
    self.update_attributes(
      billing_first_name: first_name,
      billing_last_name: last_name,
      billing_email_address: email,
      billing_organization: organization,
      billing_address: address,
      billing_address_2: address_2,
      billing_city: city,
      billing_state: state,
      billing_country: country,
      billing_zip_code: zip_code
    )
    self.save!
  end

  def update_billing_info_with_account_info
    self.update_attributes(
      billing_first_name: self.first_name,
      billing_last_name: self.last_name,
      billing_email_address: self.email,
      billing_organization: self.company,
      billing_address: self.address,
      billing_address_2: "",
      billing_city: self.city,
      billing_state: self.state,
      billing_country: self.country,
      billing_zip_code: self.zip
    )
    self.save!
  end

  def has_unread_billing_notifications?
    self.stripe_billing_notifications.where(read: false, stripe_event: "charge.failed").count > 0 ||
      self.stripe_billing_notifications.where(
        read: false,
        stripe_event: "customer.subscription.trial_will_end"
      ).count > 0 ||
      self.stripe_billing_notifications.where(
        read: false,
        stripe_event: "invoice.payment_failed"
      ).count > 0
  end

  def clients_without_next_action
    leads.client_current_pipeline_status.where(next_action: nil)
  end

  def team_clients_without_next_action
    team_leads.client_current_pipeline_status.where(next_action: nil)
  end

  def marketing_contact_activities
    contact_activities.where(activity_for: "marketing")
  end

  def team_or_solo_leads
    if user_has_teammates?
      team_leads
    else
      leads
    end
  end

  def leads_for_client_activity_recap(starttime)
    team_or_solo_leads.comments_or_tasks_updated_in_range(
      starttime,
      Time.current
    ).order("name asc")
  end

  def pending_csv_file?
    if csv_files.present? && (
      csv_files.order("csv_files ASC").last.state == "uploaded" ||
      csv_files.order("csv_files ASC").last.state == "processing"
    )
      true
    else
      false
    end
  end

  def contacts_data_in_json(query=nil)
    return [] if query.blank?

    return @data if @data.present?
    @data = []

    contact_ids =  contacts.pluck(:id) | leads.pluck(:contact_id) |
      Lead.owned_by_team_member(team_member_ids).pluck(:contact_id) |
      Lead.leads_responsible_for(self).pluck(:contact_id)

    query = "%#{query}%"

    condition = ["contacts.id IN (?) AND (contacts.name ILIKE ? OR email_addresses.email ILIKE ?)",
                 contact_ids, query, query]

    Contact.includes(:email_addresses).where(condition).references(:email_addresses).each do |c|
      c.email_addresses.each do |email_address|
        formatted_name = "#{c.name} <#{email_address.email}>"
        @data << { text: formatted_name, id: email_address.email }
      end
    end

    @data
  end

  def nylas_account_invalid?
    nylas_sync_status == NYLAS_ACCOUNT_SYNC_STATUSES["account.invalid"]
  end

  def nylas_account_valid?
    (nylas_sync_status == NYLAS_ACCOUNT_SYNC_STATUSES["account.running"]) ||
      (nylas_sync_status == NYLAS_ACCOUNT_SYNC_STATUSES["account.connected"])
  end

  def all_inbox_messages
    if has_nylas_token? && super_admin?
      InboxMessage.includes(:inbox_message_activities).all
    end
  end

  private

  def personal_subscription
    subscriptions.detect(&:active?)
  end

  def team_group_subscription
    if team_group.present?
      team_group.subscription
    end
  end

  def stripe_customer
    if stripe_customer_id.present?
      Stripe::Customer.retrieve(stripe_customer_id)
    end
  end

  def most_recently_deactivated_subscription
    [*subscriptions, team_group_subscription].
      compact.
      reject(&:active?).
      max_by(&:deactivated_on)
  end

  def generate_ab_email_address
    salt = SecureRandom.random_number(1000)

    # Removes non-alphanumeric characters.
    normalized_name = [first_name, last_name, salt].map(&:presence).
                      compact.join.downcase.gsub(/[^0-9a-z]/i, "")

    domain = Rails.application.secrets.leads["agent_bright_me_email_domain"]
    suffix_with_domain = domain.include?("@") ? domain : "@#{domain}"

    "#{normalized_name}#{suffix_with_domain}"
  end

  MAX_KEY_LENGTH                 = 7
  MAX_TRIES_TO_GENERATE_UNIQ_KEY = 7

  def generate_lead_form_key
    tries = MAX_TRIES_TO_GENERATE_UNIQ_KEY
    begin
      tries > 0 ? tries -= 1 : raise("Used max number of tries to generate new lead form key")
    end while User.exists?(lead_form_key: (key = random_lead_key))
    key
  end

  def random_lead_key
    # translates and removes -_= symbols from base64 representation string. Adapted from `Devise.friendly_token`
    SecureRandom.urlsafe_base64(MAX_KEY_LENGTH).downcase.tr("-_=", "pqr")
  end

  def set_time_zone
    self.time_zone ||= Rails.application.config.time_zone
  end

  def update_cursor
    nylas = NylasService.new(self.nylas_token)
    nylas.perform_delta_sync
  end

  def ensure_authentication_token_is_present
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
