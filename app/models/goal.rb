# == Schema Information
#
# Table name: goals
#
#  annual_transaction_goal           :decimal(, )
#  avg_commission_rate               :decimal(, )
#  avg_price_in_area                 :decimal(, )
#  calls_required_wkly               :decimal(, )
#  contacts_need_per_month           :decimal(, )
#  contacts_to_generate_one_referral :decimal(, )      default(20.0)
#  created_at                        :datetime
#  daily_calls_goal                  :integer          default(0)
#  daily_notes_goal                  :integer          default(0)
#  daily_visits_goal                 :integer          default(0)
#  desired_annual_income             :decimal(, )
#  est_business_expenses             :decimal(, )
#  gross_commission_goal             :decimal(, )
#  gross_sales_vol_required          :decimal(, )
#  id                                :integer          not null, primary key
#  monthly_transaction_goal          :decimal(, )
#  note_required_wkly                :decimal(, )
#  portion_of_agent_split            :decimal(, )
#  qtrly_transaction_goal            :decimal(, )
#  referrals_for_one_close           :decimal(, )      default(5.0)
#  total_weekly_effort               :decimal(, )
#  updated_at                        :datetime
#  user_id                           :integer
#  visits_required_wkly              :decimal(, )
#
# Indexes
#
#  index_goals_on_user_id  (user_id)
#

class Goal < ActiveRecord::Base

  PRICE_FIELDS = [:desired_annual_income, :est_business_expenses, :gross_sales_vol_required, :avg_price_in_area, :gross_commission_goal]

  # This needs to be fixed. Only add validate false whenever required, not all the time.
  belongs_to :user, autosave: true, validate: false
  # validates_numericality_of PRICE_FIELDS

  before_save :calculate_daily_notes_goal
  before_save :calculate_daily_calls_goal
  before_save :calculate_daily_visits_goal

  accepts_nested_attributes_for :user

  def self.scrub_goal_price_fields goal_params
    PRICE_FIELDS.each do |price_field|
      price_value = goal_params[price_field].presence
      goal_params[price_field] = price_value.to_s.tr(",", "") if price_value.present?
    end
    goal_params
  end

  def net_commission_goal
    desired_annual_income + est_business_expenses
  end

  def calculate_daily_notes_goal
    note_required_wkly.nil? ? self.daily_notes_goal = 0 : self.daily_notes_goal = (self.note_required_wkly / 4.0).ceil
  end

  def calculate_daily_calls_goal
    calls_required_wkly.nil? ? self.daily_calls_goal = 0 : self.daily_calls_goal = (self.calls_required_wkly / 4.0).ceil
  end

  def calculate_daily_visits_goal
    visits_required_wkly.nil? ? self.daily_visits_goal = 0 : self.daily_visits_goal = (self.visits_required_wkly / 4.0).ceil
  end

  def total_daily_referral_activities_goal
    note_required_wkly.nil? ? self.daily_notes_goal = 0 : self.daily_notes_goal = (self.note_required_wkly / 4.0).ceil #copied from above
    calls_required_wkly.nil? ? self.daily_calls_goal = 0 : self.daily_calls_goal = (self.calls_required_wkly / 4.0).ceil
    visits_required_wkly.nil? ? self.daily_visits_goal = 0 : self.daily_visits_goal = (self.visits_required_wkly / 4.0).ceil
    self.daily_notes_goal + self.daily_calls_goal + self.daily_visits_goal
  end

end
