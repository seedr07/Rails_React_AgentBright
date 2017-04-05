# == Schema Information
#
# Table name: survey_results
#
#  agent_percentage_split        :decimal(, )
#  average_home_price            :integer
#  avg_commission_rate           :decimal(, )
#  broker_fee_alternative        :boolean
#  broker_fee_alternative_split  :decimal(, )
#  broker_fee_per_transaction    :integer
#  browser                       :string
#  commission_split_type         :string
#  completed                     :boolean          default(FALSE)
#  created_at                    :datetime         not null
#  desired_annual_income         :integer
#  email                         :text
#  est_business_expenses         :integer
#  finished_at                   :datetime
#  first_name                    :text
#  franchise_fee                 :boolean
#  franchise_fee_per_transaction :decimal(, )
#  id                            :integer          not null, primary key
#  last_name                     :text
#  monthly_broker_fees_paid      :integer
#  network_id                    :string
#  next_year_plans               :string
#  other_work                    :text             default([]), is an Array
#  past_year_income              :integer
#  past_year_total_transaction   :integer
#  pays_monthly_broker_fee       :boolean
#  per_transaction_fee_capped    :boolean
#  platform                      :string
#  promotion_code                :text
#  referer                       :string
#  started_at                    :datetime
#  survey_token                  :string
#  transaction_fee_cap           :integer
#  updated_at                    :datetime         not null
#  user_agent                    :string
#  workload                      :string
#  years_experience              :integer
#  zip_code                      :integer
#

class SurveyResult < ActiveRecord::Base

  def name
    [first_name, last_name].join(" ")
  end

  def commission_rate
    avg_commission_rate || 2.5
  end

  def gross_commission
    puts "desired_annual_income: #{desired_annual_income}"
    puts "total_expenses: #{total_expenses}"
    puts "overall_agent_split_rate: #{overall_agent_split_rate}"
    ((desired_annual_income + total_expenses) / overall_agent_split_rate) * 100
  end

  def gross_sales_volume
    gross_commission / commission_rate * 100
  end

  def estimated_number_of_sides
    gross_sales_volume / average_home_price
  end

  def annual_transaction_goal
    gross_sales_volume / average_home_price
  end

  def quarterly_transaction_goal
    annual_transaction_goal / 4
  end

  def monthly_transaction_goal
    annual_transaction_goal / 12
  end

  def total_expenses
    est_business_expenses + ((monthly_broker_fees_paid || 0) * 12)
  end

  def average_gross_commission
    (commission_rate * average_home_price) / 100
  end

  def agent_fee_split
    (1 - broker_fee_per_transaction / average_gross_commission) * 100
  end

  def overall_agent_split_rate
    if franchise_fee
      puts "Has franchise fee.."
      case commission_split_type
      when "Percentage"
        (1 - franchise_fee_per_transaction / 100 ) * agent_percentage_split
      when "Fee"
        ((average_gross_commission * (1 - franchise_fee_per_transaction / 100) - broker_fee_per_transaction) / average_gross_commission) * 100
      else
        100
      end
    else
      case commission_split_type
      when "Percentage"
        agent_percentage_split
      when "Fee"
        agent_fee_split
      else
        100
      end
    end
  end

  # the following are the Activity Goals Calculations - any changes here should also be made in activity_goals_calculator.js.coffee

  def referrals_needed_per_month
    5 * monthly_transaction_goal
  end

  def communications_needed_per_month
    referrals_needed_per_month * 20
  end

  # Weekly Effort Calculation
  def suggested_total_weekly_effort
    communications_needed_per_month / 4.16
  end

  def suggested_calls_needed_per_week
    suggested_total_weekly_effort * 0.35
  end

  def suggested_note_required_per_week
    suggested_total_weekly_effort * 0.50
  end

  def suggested_visits_required_per_week
    suggested_total_weekly_effort * 0.15
  end

  # Daily Effort Calculation
  def suggested_total_daily_effort
    suggested_total_weekly_effort / 4
  end

  def suggested_calls_needed_per_day
    suggested_calls_needed_per_week / 4
  end

  def suggested_note_required_per_day
    suggested_note_required_per_week / 4
  end

  def suggested_visits_required_per_day
    suggested_visits_required_per_week / 4
  end
end
