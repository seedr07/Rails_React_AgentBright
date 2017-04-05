# == Schema Information
#
# Table name: contacts
#
#  active                       :boolean          default(TRUE)
#  avatar_color                 :integer          default(0)
#  birthday                     :string
#  company                      :string
#  created_at                   :datetime
#  created_by_user_id           :integer
#  data                         :hstore           default({})
#  email                        :string
#  envelope_salutation          :string
#  first_name                   :string
#  google_api_contact_id        :string
#  grade                        :integer
#  graded_at                    :datetime
#  id                           :integer          not null, primary key
#  import_source_id             :integer
#  import_source_type           :string
#  inactive_at                  :datetime
#  last_activity_at             :datetime
#  last_called_at               :datetime
#  last_contacted_at            :datetime
#  last_name                    :string
#  last_note_sent_at            :datetime
#  last_visited_at              :datetime
#  letter_salutation            :string
#  mandrill_email_interactions  :string           default("")
#  mandrill_message_id_list     :string           default([]), is an Array
#  mandrill_message_ids_string  :string
#  minutes_since_last_contacted :integer
#  name                         :string
#  next_activity_at             :datetime
#  next_call_at                 :datetime
#  next_note_at                 :datetime
#  next_visit_at                :datetime
#  phone_number                 :string
#  profession                   :string
#  search_status                :string
#  search_status_code           :integer
#  search_status_message        :string
#  spouse_first_name            :string
#  spouse_last_name             :string
#  suggested_facebook_url       :string
#  suggested_first_name         :string
#  suggested_googleplus_url     :string
#  suggested_instagram_url      :string
#  suggested_job_title          :string
#  suggested_last_name          :string
#  suggested_linkedin_bio       :string
#  suggested_linkedin_url       :string
#  suggested_location           :string
#  suggested_organization_name  :string
#  suggested_twitter_url        :string
#  suggested_youtube_url        :string
#  suggestion_received          :datetime
#  title                        :string
#  updated_at                   :datetime
#  user_id                      :integer
#  yahoo_contact_id             :string
#
# Indexes
#
#  index_contacts_on_active                        (active)
#  index_contacts_on_created_by_user_id            (created_by_user_id)
#  index_contacts_on_email                         (email)
#  index_contacts_on_grade                         (grade)
#  index_contacts_on_name                          (name)
#  index_contacts_on_phone_number                  (phone_number)
#  index_contacts_on_user_id                       (user_id)
#  index_contacts_on_user_id_and_active_and_grade  (user_id,active,grade)
#

class Contact < ActiveRecord::Base

  CONTACT_DAYS = { 0 => 30.days, 1 => 60.days, 2 => 90.days, 3 => 120.days, 4 => 120.days, 5 => 120.days }.freeze
  DEFAULT_GROUPS_LIST = [
    "Agent", "Appraiser", "Attorney", "B2B", "Business Owner", "Family",
    "Friend", "Home Inspector", "Insurance", "Mortgage Broker", "Past Client",
    "Sphere Of Influence"].freeze
  GRADES = [["A+", 0], ["A", 1], ["B", 2], ["C", 3], ["D", 4], ["-", 5]].freeze
  GRADES_IDS = GRADES.collect { |_notation, id| id }.freeze

  include ActivityWatcher
  include PublicActivity::Model
  include RecentActivity

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :contact_groups

  belongs_to :created_by_user, class_name: "User", inverse_of: :contacts_created
  belongs_to :import_source, polymorphic: true
  belongs_to :user, counter_cache: true
  has_many :addresses, as: :owner, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :contact_activities, dependent: :destroy
  has_many :email_addresses, as: :owner, dependent: :destroy
  has_many :mandrill_messages, dependent: :destroy
  has_many :phone_numbers, as: :owner, dependent: :destroy
  has_many :print_campaign_messages, dependent: :destroy
  has_many :leads
  has_many :referrals, class_name: "Lead", inverse_of: :referring_contact,
                       foreign_key: "referring_contact_id", dependent: :nullify
  has_many :tasks, as: :taskable, dependent: :destroy
  has_one :api_suggested_image, as: :attachable, class_name: "Image", dependent: :destroy
  has_one :contact_image, as: :attachable, class_name: "Image", dependent: :destroy

  accepts_nested_attributes_for :api_suggested_image, :addresses, :contact_image
  accepts_nested_attributes_for :phone_numbers, :email_addresses, allow_destroy: true

  attr_accessor :require_base_validations, :require_basic_validations,
                :typeahead_query_name, :required_salutations_to_set,
                :force_reload

  validates :grade, inclusion: { in: GRADES_IDS, allow_nil: true }
  validates :created_by_user_id, presence: true
  validate :base_validations, if: :require_base_validations?
  validate :basic_validations, if: :require_basic_validations?

  after_create :call_contact_api
  after_create :set_ungraded_contacts_count
  after_destroy :set_ungraded_contacts_count
  after_update :set_ungraded_contacts_count_if_changed
  after_save :set_primary_email_and_phone_for_last_record
  before_create :set_avatar_background_color
  before_save :set_name
  before_save :set_salutations, if: :required_salutations_to_set?
  before_save :set_force_reload, if: :reloading_needed?
  after_save :force_reload!, if: :force_reload_needed?

  scope :active, -> { where(active: true) }
  scope :by_grade, -> (grade) { where("grade = ?", grade) }
  scope :by_user_and_email, ->(user, email) do
    joins(:email_addresses).where(user: user).where("email_addresses.email = ? ", email)
  end
  scope :grad_a_plus, -> { where(grade: 0) }
  scope :grad_a_plus_abc, -> { where("grade in (0,1,2,3)") }
  scope :graded, -> { where.not(grade: nil) }
  scope :next_contacts_to_call, ->(today) { where("next_call_at <= ? OR next_call_at is null", today) }
  scope :next_contacts_to_write_notes, ->(today) { where("next_note_at <= ? OR next_note_at is null", today) }
  scope :next_contacts_to_visit, ->(today) { where("next_visit_at <= ? OR next_visit_at is null", today) }
  scope :records_for_minutes_since_last_contacted, ->(minutes) { where("minutes_since_last_contacted >= ?", minutes) }
  scope :relationships, -> { where("grade <= ?", 3) }
  scope :search_name, ->(search_term) do
    where("first_name ILIKE :search_term OR last_name ILIKE :search_term", search_term: "%#{search_term.downcase}%")
  end
  scope :time_since_last_activity, ->(time) do
    where("last_activity_at <= ? OR last_activity_at is null", (Time.current - time))
  end
  scope :ungraded, -> { where(grade: nil) }

  tracked(
    owner: proc { |controller, _contact| controller.current_user if controller },
    recipient: proc { |_controller, contact| contact },
    params: {
      changes: :activity_parameters_changes,
      name: :full_name
    },
    on: {
      update: proc do |model, _|
        model.savable_activity?(model.activity_parameters_changes)
      end
    }
  )

  recent_activities_for(
    self: {
      attributes: [
        :company,
        :envelope_salutation,
        :first_name,
        :grade,
        :last_name,
        :spouse_first_name,
        :title
      ]
    },
    associations: {
      addresses: { attributes: [:city, :state, :street, :zip] },
      email_addresses: { attributes: [:email, :email_type] },
      phone_numbers: { attributes: [:number, :number_type] }
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
      condition: ->(contact) do
        {
          recipient_id: contact.id,
          recipient_type: contact.class.to_s,
          key: [
            "contact_activity.create",
            "contact_activity.destroy",
            "contact_activity.update"
          ]
        }
      end
    },
    mandrill_message: {
      condition: -> (contact) do
        {
          recipient_id: contact.id,
          recipient_type: contact.class.to_s,
          key: ["mandrill_message.create"]
        }
      end
    },
    tasks: {
      condition: ->(contact) do
        {
          recipient_id: contact.id,
          recipient_type: contact.class.to_s,
          key: ["task.create", "task.complete", "task.destroy", "task.update"]
        }
      end
    }
  )

  def name
    # If contact's name is nil, then fetch name from the full_name method.
    self[:name] || full_name
  end

  def set_name
    if first_name || last_name
      self[:name] = self.full_name
    end
  end

  def full_name
    [first_name, last_name].map(&:presence).compact.join(" ")
  end

  def initials
    [first_name, last_name].map(&:presence).compact.map(&->(s) { s[0] }).join
  end

  def initial
    full_name[0]
  end

  def set_avatar_background_color
    self.avatar_color = Random.rand(12)
  end

  def avatar_class
    if self.avatar_color
      "abg#{self.avatar_color}"
    else
      "abg0"
    end
  end

  def display_image
    if contact_image
      contact_image
    elsif api_suggested_image
      api_suggested_image
    end
  end

  def grade_to_s
    grade.nil? ? " ? " : GRADES[grade][0]
  end

  def last_activity_completed
    contact_activities.order("completed_at asc").last
  end

  def last_activity_completed_by_type(type)
    contact_activities.activities_by_type(type).order("completed_at asc").last
  end

  def last_called_at_to_s
    last_called_at.nil? ? "No calls made" : last_called_at.to_date.to_s(:cal_date)
  end

  def last_note_sent_at_to_s
    last_note_sent_at.nil? ? "No notes written" : last_note_sent_at.to_date.to_s(:cal_date)
  end

  def last_visited_at_to_s
    last_visited_at.nil? ? "No visits" : last_visited_at.to_date.to_s(:cal_date)
  end

  def self.random_ungraded_contact(exclude_contact_id=nil)
    ungraded_contact = Contact.ungraded
    if exclude_contact_id
      ungraded_contact = ungraded_contact.where.not(id: exclude_contact_id)
    end
    ungraded_contact.order("random()").first
  end

  def set_ungraded_contacts_count
    if self.user
      self.user.ungraded_contacts_count = self.user.contacts.active.ungraded.count
      self.user.save!
    end
  end

  def set_ungraded_contacts_count_if_changed
    # NOTE: 'ungraded_contacts_count' column should get updated when contacts
    # 'grade' column gets changed as well as 'active' column gets changed.

    if self.user && (self.changed.include?("grade") || self.changed.include?("active"))
      self.user.update!(ungraded_contacts_count: self.user.contacts.active.ungraded.count)
    end
  end

  def last_contacted_date
    [self.last_note_sent_at, self.last_called_at, self.last_visited_at].compact.max
  end

  def next_contact_date
    [self.next_note_at, self.next_call_at, self.next_visit_at].compact.min
  end

  def number_of_touches_ytd
    contact_activities.year_to_date.count
  end

  def primary_phone_number
    phones = phone_numbers.order("created_at ASC")
    phones.find_by(primary: true) || phones.first
  end

  def primary_email_address
    emails = email_addresses.order("created_at ASC")
    emails.find_by(primary: true) || emails.first
  end

  def primary_address
    addresses.first
  end

  def all_emails
    email_addresses.pluck(:email)
  end

  def touch_frequency
    activities_for_contact = contact_activities.completed_this_year
    if activities_for_contact.count > 1
      activities_ordered_by_date = activities_for_contact.order("completed_at asc")
      first_activity_date = activities_ordered_by_date.first.completed_at
      (Time.current.to_date - first_activity_date.to_date).to_i / (activities_for_contact.count - 1)
    else
      0
    end
  end

  def contact_groups_by_user(current_user)
    self.contact_groups_from(current_user)
  end

  def mark_as_inactive!
    self.active = false
    self.inactive_at = Time.current
    save!
  end

  def self.find_from_email(user, email)
    user.contacts.joins(:email_addresses).find_by(email_addresses: { email: email })
  end

  def call_contact_api
    if Rails.env != "rake"
      Contact.delay.call_fullcontact_api(self.id)
    end
  end

  def refresh_contact_api_info
    FullContactInfoUpdater.new(self.id).update_all_and_save
  end

  def self.call_fullcontact_api(id)
    FullContactInfoUpdater.new(id).update_all_and_save
  end

  def call_inboxapp(token)
    Util.log "Token: #{token}"
    primary_email = self.primary_email_address
    if primary_email && token
      email_address = primary_email.email
      NylasApi::Thread.new(token: token).find_by_email_address(email_address)
    end
  end

  def fetch_email_messages(token)
    if all_emails.present? && token
      NylasApi::Message.new(token: token).find_by_email_addresses(all_emails)
    end
  end

  def social_info_present?
    [suggested_first_name, suggested_last_name,
     suggested_location, suggested_organization_name,
     suggested_job_title, suggested_linkedin_bio,
     suggested_facebook_url, suggested_linkedin_url,
     suggested_twitter_url, suggested_googleplus_url,
     suggested_instagram_url, suggested_youtube_url].select(&:present?).any?
  end

  def has_a_valid_primary_email_address?
    primary_email = self.primary_email_address
    if primary_email
      email_address = primary_email.email
      if email_address
        ValidateEmail.valid?(email_address)
      else
        false
      end
    else
      false
    end
  end

  def received_email_messages
    user.email_messages.where(
    "from_email = ? AND ? = ANY (to_email_addresses)",
    user.nylas_connected_email_account,
    email
    )
  end

  def received_email_messages_total_count
    received_email_messages.count
  end

  def received_email_messages_in_last_year_count
    received_email_messages.where("received_at >= ?", 1.year.ago).count
  end

  def last_received_email_sent_at
    received_email_messages.maximum(:received_at)
  end

  def overall_last_contacted_at
    [last_received_email_sent_at, last_contacted_date].compact.max
  end

  def received_email_messages_total_count_from_nylas
    return @total_count if @total_count.present?

    from  = user.nylas_connected_email_account
    to    = email
    @total_count = nylas_message_object.total_count(from: from, to: to)
  end

  def received_email_messages_in_past_year_count_from_nylas
    return @past_year_count if @past_year_count.present?

    from  = user.nylas_connected_email_account
    to    = email
    @past_year_count = nylas_message_object.past_year_count(from: from, to: to)
  end

  def last_received_email_sent_at_from_nylas
    return  @last_sent_at if @last_sent_at.present?

    from  = user.nylas_connected_email_account
    to    = email
    @last_sent_at = nylas_message_object.last_email_sent_at(from: from, to: to)
  end

  def overall_last_contacted_at_from_nylas
    [last_received_email_sent_at_from_nylas, last_contacted_date].compact.max
  end

  def email_blank?
    email_addresses.collect(&:email).all?(&:blank?)
  end

  def phone_blank?
    phone_numbers.collect(&:number).all?(&:blank?)
  end

  def set_salutations
    format_envelope_salutation
    format_letter_salutation
  end

  def format_envelope_salutation
    strip_salutation_related_attributes
    self.envelope_salutation = Contact::SalutationService.new(self).envelope
  end

  def format_letter_salutation
    strip_salutation_related_attributes
    self.letter_salutation = Contact::SalutationService.new(self).letter
  end

  def strip_salutation_related_attributes
    [:spouse_first_name, :spouse_last_name, :first_name, :last_name].map do |attr|
      new_value = public_send(attr).try(:strip)
      self.public_send("#{attr}=", new_value)
    end
  end

  private

  def nylas_message_object
    @nylas_msg_object ||= NylasApi::Message.new(token: user.nylas_token)
  end

  def require_base_validations?
    require_base_validations.to_s == "true"
  end

  def require_basic_validations?
    require_basic_validations.to_s == "true"
  end

  def valid_base_validations?
    first_name.blank? && last_name.blank?
  end

  def valid_basic_validations?
    valid_base_validations? && last_name.blank? && email_blank? && phone_blank?
  end

  def base_validations
    if valid_base_validations?
      errors.add(:first_name, "Please enter a first name")
      errors.add(:last_name, "...or a last name")
    end
  end

  def basic_validations
    if valid_basic_validations?
      errors.add(:base, "Enter at least first name, last name, email or phone number")
    end
  end

  def required_salutations_to_set?
    required_salutations_to_set.to_s == "true"
  end

  def set_primary_email_and_phone_for_last_record
    if self.email_addresses.count == 1
      email_address = self.email_addresses.first
      email_address.primary = true
      email_address.save
    end

    if self.phone_numbers.count == 1
      phone_number = self.phone_numbers.first
      phone_number.primary = true
      phone_number.save
    end
  end

  def reloading_needed?
    # NOTE: This is currently handling all nested attributes. We need this
    # logic only for nested email addresses and phone numbers attributes and
    # that's why we need to better checks here for email addresses and phone
    # numbers and not for all.
    # Refer: #2255 (Github)

    send(:nested_records_changed_for_autosave?)
  end

  def set_force_reload
    self.force_reload = true
  end

  def force_reload_needed?
    self.force_reload
  end

  def force_reload!
    self.reload
  end

end
