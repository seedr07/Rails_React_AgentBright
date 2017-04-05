# == Schema Information
#
# Table name: tasks
#
#  assigned_to_id  :integer
#  completed       :boolean          default(FALSE), not null
#  completed_at    :datetime
#  completed_by_id :integer
#  created_at      :datetime
#  due_date_at     :datetime
#  id              :integer          not null, primary key
#  is_next_action  :boolean          default(FALSE), not null
#  subject         :string
#  taskable_id     :integer
#  taskable_type   :string
#  type_associated :string
#  updated_at      :datetime
#  user_id         :integer
#
# Indexes
#
#  index_tasks_on_assigned_to_id                 (assigned_to_id)
#  index_tasks_on_completed_by_id                (completed_by_id)
#  index_tasks_on_taskable_id_and_taskable_type  (taskable_id,taskable_type)
#  index_tasks_on_type_associated                (type_associated)
#  index_tasks_on_user_id                        (user_id)
#

class Task < ActiveRecord::Base

  attr_accessor :postpone, :next_action, :is_next_action

  belongs_to :taskable, polymorphic: true, touch: true
  belongs_to :user
  belongs_to :assigned_to, class_name: "User", inverse_of: :tasks_assigned
  belongs_to :completed_by, class_name: "User", inverse_of: :tasks_completed
  has_one :next_action_lead, class_name: "Lead", inverse_of: :next_action, foreign_key: "next_action_id", dependent: :nullify

  TIME_FROM_NOW = {
    "tomorrow" => 1.day,
    "3 days from now" => 3.days,
    "next week" => 7.days
  }

  scope :assigned_to_team_member, ->(owner_ids) { where("tasks.assigned_to_id IN (?)", owner_ids) }
  scope :completed, -> { where("completed is true") }
  scope :completed_today, -> { where("completed_at between ? and ?", Time.current.beginning_of_day, Time.current.end_of_day) }
  scope :completed_within_date_range, -> (starttime, endtime) { where "(completed_at >= ? AND completed_at <= ?)", starttime, endtime }
  scope :created_or_completed_within_date_range, -> (starttime, endtime) { where "(completed_at >= ? AND completed_at <= ?) OR (created_at >= ? AND created_at <= ?)", starttime, endtime, starttime, endtime }
  scope :created_within_date_range, -> (starttime, endtime) { where "(created_at >= ? AND created_at <= ?)", starttime, endtime }
  scope :due_after, ->(datetime) { where("due_date_at > ?", datetime) }
  scope :due_before, ->(datetime) { where("due_date_at < ?", datetime) }
  scope :due_between, -> (startdate, enddate) { where("due_date_at < ? AND due_date_at > ?", enddate, startdate) }
  scope :due_today, -> { where("due_date_at between ? and ?", Time.current.beginning_of_day, Time.current.end_of_day) }
  scope :not_completed, -> { where("completed is not true") }
  scope :owned_by_team_member, ->(owner_ids) { where("tasks.user_id IN (?)", owner_ids) }

  validates :subject, presence: { message: "can't be blank" }

  before_save :set_taskable
  before_destroy :remove_and_update_next_action
  after_create :set_incomplete_lead_task_counter
  after_update :set_incomplete_lead_task_counter_if_changed
  after_destroy :set_incomplete_lead_task_counter
  after_save :update_next_action

  include PublicActivity::Model
  tracked(
    owner: proc { |controller, _| controller.current_user if controller },
    recipient: proc { |_, task| task.taskable },
    params: { changes: :changes, name: :subject },
    on: { update: proc { |model, _| model.changes.keys != ["updated_at"] } }
  )

  def postpone=(postpone)
    self.due_date_at = Time.current + postpone.to_i if postpone.present?
  end

  def postpone
  end

  def is_next_action?
    next_action_lead.present?
  end

  def is_overdue?
    if due_date_at && completed == false
      due_date_at <= Time.current.end_of_day - 1.day
    end
  end

  def is_due_today?
    if due_date_at
      due_date_at < Time.current.end_of_day && due_date_at >= Time.current.beginning_of_day
    end
  end

  def is_due_tomorrow?
    if due_date_at
      due_date_at < Time.current.end_of_day + 1.day && due_date_at >= Time.current.beginning_of_day + 1.day
    end
  end

  def lead_has_next_action?
    taskable.next_action.present?
  end

  def is_leads_next_action?
    next_action_lead == taskable
  end

  def update_next_action
    if belongs_to_lead?
      if completed
        find_a_task_and_save_as_lead_next_action(taskable)
      else
        set_next_action_for_associated_lead(taskable)
      end
    end
  end

  def remove_and_update_next_action
    if belongs_to_lead?
      taskable.next_action = taskable.find_second_to_next_action
      taskable.save!
    end
  end

  def taskable_class
    if taskable_type == "Client"
      "Lead"
    else
      taskable_type
    end
  end

  def related_to
    taskable_class.classify.constantize.find(taskable_id)
  end

  def set_incomplete_lead_task_counter
    if self.taskable_type == "Lead" && self.taskable_id
      self.taskable.incomplete_tasks_count = self.taskable.tasks.not_completed.count
    end
  end

  def set_incomplete_lead_task_counter_if_changed
    if self.taskable_type == "Lead" && self.taskable_id && self.changed.include?('completed')
      self.taskable.incomplete_tasks_count = self.taskable.tasks.not_completed.count
    end
  end

  def completed_by_name
    completed_by.full_name if completed_by
  end

  def assigned_to_name
    assigned_to.full_name if assigned_to
  end

  def belongs_to_lead?
    taskable.present? && taskable_type == "Lead"
  end

  private

  def find_a_task_and_save_as_lead_next_action(lead)
    if task_with_earliest_due_date = lead.find_next_action
      lead.next_action = task_with_earliest_due_date
    else
      lead.next_action = nil
    end
    lead.save!
  end

  def set_next_action_for_associated_lead(lead)
    if is_next_action
      set_this_task_as_the_lead_next_action(lead)
    else
      find_a_task_and_save_as_lead_next_action(lead)
    end
  end

  def set_this_task_as_the_lead_next_action(lead)
    lead.next_action = self
    lead.save!
  end

  def set_taskable
    if ["Lead/Client", "Client"].include? self.taskable_type
      self.taskable_type = "Lead"
    end

    if self.taskable_type == "None" || self.taskable_type.blank?
      self.taskable = nil
    end
  end
end
