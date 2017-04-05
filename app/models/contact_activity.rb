# == Schema Information
#
# Table name: contact_activities
#
#  activity_for       :string
#  activity_type      :string
#  asked_for_referral :boolean          default(FALSE)
#  comments           :text
#  completed_at       :datetime
#  contact_id         :integer
#  created_at         :datetime
#  id                 :integer          not null, primary key
#  lead_id            :integer
#  received_referral  :boolean
#  replied_to         :boolean          default(FALSE)
#  subject            :string
#  updated_at         :datetime
#  user_id            :integer
#
# Indexes
#
#  index_contact_activities_on_activity_for        (activity_for)
#  index_contact_activities_on_activity_type       (activity_type)
#  index_contact_activities_on_asked_for_referral  (asked_for_referral)
#  index_contact_activities_on_contact_id          (contact_id)
#  index_contact_activities_on_lead_id             (lead_id)
#  index_contact_activities_on_received_referral   (received_referral)
#  index_contact_activities_on_replied_to          (replied_to)
#  index_contact_activities_on_user_id             (user_id)
#

class ContactActivity < ActiveRecord::Base

  ACTIVITY_FOR = %w(marketing lead).freeze

  belongs_to :contact
  belongs_to :lead
  belongs_to :user

  validates :user_id, :contact_id, :completed_at, presence: true

  after_create :set_last_activity_at, :increase_wkly_and_daily_counter

  include PublicActivity::Model
  tracked(
    owner: proc { |controller, _contact_activity| controller.current_user if controller },
    recipient: proc { |_, contact_activity| contact_activity.contact },
    associable_id: proc { |_, contact_activity| contact_activity.lead.try(:id) },
    associable_type: proc { |_, contact_activity| contact_activity.lead.try(:class).try(:to_s) },
    params: {
      changes: :required_changes,
      name: :subject
    },
    on: {
      update: proc do |model, _controller|
        model.changes.keys != ["updated_at"]
      end
    }
  )

  scope :activities_by_type, ->(type) { where(activity_type: type) }
  scope :calls, -> { where(activity_type: "Call") }
  scope :notes, -> { where(activity_type: "Note") }
  scope :visits, -> { where(activity_type: "Visit") }

  def self.completed_this_week(type)
    activities_by_type(type).
      where(completed_at: Time.current.beginning_of_week..Time.current.end_of_week)
  end

  def self.completed_this_year
    where(completed_at: Time.current.beginning_of_year..Time.current.end_of_year)
  end

  def self.completed_today(type=nil)
    activities_by_type(type).
      where(completed_at: Time.current.beginning_of_day..Time.current.end_of_day)
  end

  def self.year_to_date
    where(completed_at: Time.current.beginning_of_year..Time.current)
  end

  def self.completed_yesterday(type)
    activities_by_type(type).
      where(completed_at: (Time.current.beginning_of_day - 1.day)..(Time.current.end_of_day - 1.day))
  end

  def custom_time
    "Specify time..."
  end

  def custom_time=(custom_time)
    self.completed_at = Time.zone.now if custom_time == "Just now"
  end

  private

  def set_last_activity_at
    case self.activity_type
    when "Note"
      update_contact_note_dates
    when "Call"
      update_contact_call_dates
    when "Visit"
      update_contact_visit_dates
    end

    contact.last_activity_at = contact.last_contacted_date
    contact.next_activity_at = contact.next_contact_date
    contact.save
  end

  def update_contact_note_dates
    contact.last_note_sent_at = self.completed_at
    if contact.grade
      contact.next_note_at = contact.last_note_sent_at + Contact::CONTACT_DAYS[contact.grade.to_i]
    end
  end

  def update_contact_call_dates
    contact.last_called_at = self.completed_at
    if contact.grade
      contact.next_call_at = contact.last_called_at + Contact::CONTACT_DAYS[contact.grade.to_i]
    end
  end

  def update_contact_visit_dates
    contact.last_visited_at = self.completed_at
    if contact.grade
      contact.next_visit_at = contact.last_visited_at + Contact::CONTACT_DAYS[contact.grade.to_i]
    end
  end

  def increase_wkly_and_daily_counter
    if ["Note", "Call", "Visit"].include?(self.activity_type)
      user.increment!(:wkly_notes_counter, 1)
      user.increment!(:dly_notes_counter, 1)
    end
  end

  def required_changes
    return changes if changes.blank?

    changes.keep_if do |key, _|
      keep_attributes.include? key.to_sym
    end
  end

  def keep_attributes
    [:activity_type, :asked_for_referral, :comments, :received_referral, :subject]
  end

end
