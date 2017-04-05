#= require 'common/pages/interactive_goals_view'
#= require 'common/calculations/activity_goals_calculator'

class window.ActivityGoalsView extends window.InteractiveGoalsView

  inputMapping:
    referralsNeededPerClosedSale:    '[data-goal-param=referrals_needed_per_closed_sale]'
    communicationsNeededPerReferral: '[data-goal-param=communications_needed_per_referral]'
    monthlyTransactionGoal:          '[data-goal-param=monthly_transaction_goal]'

  changeMapping:
    incomeGoal:                      '[data-goal-param=income_goal]'
    estBusinessExpenses:             '[data-goal-param=est_business_expenses]'
    agentSplit:                      '[data-goal-param=agent_split]'
    avgCommissionRate:               '[data-goal-param=avg_commission_rate]'
    avgCommissionRateFee:            '[data-goal-param=avg_commission_rate_fee]'
    avgSalesPrice:                   '[data-goal-param=avg_sales_price]'
    avgSalesPriceFee:                '[data-goal-param=avg_sales_price_fee]'
    sugTotalWeeklyEffort:            '[data-goal-param=suggested_total_weekly_effort]'
    sugCallsNeededPerWeek:           '[data-goal-param=suggested_calls_needed_per_week]'
    sugNoteRequiredWkly:             '[data-goal-param=suggested_note_required_wkly]'
    sugVisitsRequiredWkly:           '[data-goal-param=suggested_visits_required_wkly]'
    monthlyBrokerFeesPaid:           '[data-goal-param=monthly_broker_fees_paid]'
    brokerFeePerTransaction:         '[data-goal-param=broker_fee_per_transaction]'
    franchiseFeePerTransaction:      '[data-goal-param=franchise_fee_per_transaction]'
    franchiseFeeRadio:               "[data-calc=franchise-fee-radio]"
    commissionSplitTypeRadio:        "[data-calc=commission-split-type-radio]"
    brokerFeeAlternativeRadio:       "[data-calc=broker-fee-alternative-radio]"
    perTransactionFeeCappedRadio:    "[data-calc=per-transaction-fee-capped-radio]"

  resultMapping:
    referralsNeededPerMonth:         '[data-goal-param=referrals_needed_per_month]'
    communicationsNeededPerMonth:    '[data-goal-param=communicaions_needed_per_month]'
    suggestedCallsNeededPerWeek:     '[data-goal-param=suggested_calls_needed_per_week]'
    suggestedTotalWeeklyEffort:      '[data-goal-param=suggested_total_weekly_effort]'
    suggestedNoteRequiredPerWeek:    '[data-goal-param=suggested_note_required_wkly]'
    suggestedVisitsRequiredPerWeek:  '[data-goal-param=suggested_visits_required_wkly]'
    suggestedCallsNeededDaily:       '[data-goal-param=suggested_calls_needed_daily]'
    suggestedTotalDailyEffort:       '[data-goal-param=suggested_total_daily_effort]'
    suggestedNoteRequiredPerDay:     '[data-goal-param=suggested_note_required_daily]'
    suggestedVisitsRequiredPerDay:   '[data-goal-param=suggested_visits_required_daily]'

  valid: =>
    @validNumbers(@referralsNeededPerClosedSale, @communicationsNeededPerReferral, @monthlyTransactionGoal)

  calculate: =>
    calc = new ActivityGoalsCalculator(@referralsNeededPerClosedSale, @communicationsNeededPerReferral, @monthlyTransactionGoal)

    @referralsNeededPerMonth      = calc.referralsNeededPerMonth()
    @communicationsNeededPerMonth = calc.communicationsNeededPerMonth()
    # Weekly Effort
    @suggestedCallsNeededPerWeek  = calc.suggestedCallsNeededPerWeek()
    @suggestedTotalWeeklyEffort  = calc.suggestedTotalWeeklyEffort()
    @suggestedNoteRequiredPerWeek  = calc.suggestedNoteRequiredPerWeek()
    @suggestedVisitsRequiredPerWeek  = calc.suggestedVisitsRequiredPerWeek()
    # Daily Effort
    @suggestedCallsNeededDaily = calc.suggestedCallsNeededPerDay()
    @suggestedTotalDailyEffort = calc.suggestedTotalDailyEffort()
    @suggestedNoteRequiredPerDay = calc.suggestedNoteRequiredPerDay()
    @suggestedVisitsRequiredPerDay = calc.suggestedVisitsRequiredPerDay()

document.addEventListener "turbolinks:load", ->
  if $('[data-goal-param]').length
    activity_goals_view = new ActivityGoalsView()
    console.log("new ActivityGoalsView")
    activity_goals_view.render()

