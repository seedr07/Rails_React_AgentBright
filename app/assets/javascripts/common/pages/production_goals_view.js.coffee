#= require 'common/pages/interactive_goals_view'
#= require 'common/calculations/production_goals_calculator'

class ProductionGoalsView extends InteractiveGoalsView
  inputMapping:
    incomeGoal:                 '[data-goal-param=income_goal]'
    estBusinessExpenses:        '[data-goal-param=est_business_expenses]'
    agentSplit:                 '[data-goal-param=agent_split]'
    avgCommissionRate:          '[data-goal-param=avg_commission_rate]'
    avgCommissionRateFee:       '[data-goal-param=avg_commission_rate_fee]'
    avgSalesPrice:              '[data-goal-param=avg_sales_price]'
    avgSalesPriceFee:           '[data-goal-param=avg_sales_price_fee]'
    sugTotalWeeklyEffort:       '[data-goal-param=suggested_total_weekly_effort]'
    sugCallsNeededPerWeek:      '[data-goal-param=suggested_calls_needed_per_week]'
    sugNoteRequiredWkly:        '[data-goal-param=suggested_note_required_wkly]'
    sugVisitsRequiredWkly:      '[data-goal-param=suggested_visits_required_wkly]'
    monthlyBrokerFeesPaid:      '[data-goal-param=monthly_broker_fees_paid]'
    brokerFeePerTransaction:    '[data-goal-param=broker_fee_per_transaction]'
    franchiseFeePerTransaction: '[data-goal-param=franchise_fee_per_transaction]'

  changeMapping:
    franchiseFeeRadio:            "[data-calc=franchise-fee-radio]"
    commissionSplitTypeRadio:     "[data-calc=commission-split-type-radio]"
    brokerFeeAlternativeRadio:    "[data-calc=broker-fee-alternative-radio]"
    perTransactionFeeCappedRadio: "[data-calc=per-transaction-fee-capped-radio]"

  resultMapping:
    grossCommissionGoal:      '[data-goal-param=gross_commission_goal]'
    salesVolumeNeeded:        '[data-goal-param=sales_volume_needed]'
    annualTransactionGoal:    '[data-goal-param=annual_transaction_goal]'
    quarterlyTransactionGoal: '[data-goal-param=quarterly_transaction_goal]'
    monthlyTransactionGoal:   '[data-goal-param=monthly_transaction_goal]'
    totalExpenses:            '[data-goal-param=total_expenses]'
    avgGrossCommission:       '[data-goal-param=average_gross_commission]'
    effFeeRate:               '[data-goal-param=effective_fee_rate]'
    effPrecentageRate:        '[data-goal-param=effective_percentage_rate]'
    effFranchiseFeeRate:      '[data-goal-param=effective_franchise_fee_rate]'

  valid: =>
    @validNumbers(
      @incomeGoal,
      @estBusinessExpenses
    )

  calculate: =>
    calc = new ProductionGoalsCalculator(
      @incomeGoal,
      @estBusinessExpenses,
      @agentSplit,
      @avgCommissionRate,
      @avgCommissionRateFee,
      @avgSalesPrice,
      @avgSalesPriceFee,
      @monthlyBrokerFeesPaid,
      @brokerFeePerTransaction,
      @franchiseFeePerTransaction
    )

    @activeAvgCommissionRate   = calc.activeAvgCommissionRate()
    @activeAvgSalesPrice       = calc.activeAvgSalesPrice()
    @grossCommissionGoal       = calc.grossCommissionGoal()
    @salesVolumeNeeded         = calc.salesVolumeNeeded()

    @annualTransactionGoal     = calc.annualTransactionGoal()
    @quarterlyTransactionGoal  = calc.quarterlyTransactionGoal()
    @monthlyTransactionGoal    = calc.monthlyTransactionGoal()

    @totalExpenses             = calc.totalExpenses()
    @avgGrossCommission        = calc.avgGrossCommission()
    @effFeeRate                = calc.effFeeRate()
    @effPrecentageRate         = calc.effPrecentageRate()
    @effFranchiseFeeRate       = calc.effFranchiseFeeRate()

document.addEventListener "turbolinks:load", ->
  if $('[data-goal-param]').length
    new ProductionGoalsView()
    console.log "new ProductionGoalsView"
    if $("[data-calc='commission-split-type-radio']:checked").val() == "Percentage"
      $("[data-display='percentage']").show()
      $("[data-display='percentage'] input").prop "disabled", false
      $("[data-display='fee']").hide()
      $("[data-display='fee'] input").prop "disabled", true
    if $("[data-calc='commission-split-type-radio']:checked").val() == "Fee"
      $("[data-display='percentage']").hide()
      $("[data-display='percentage'] input").prop "disabled", true
      $("[data-display='fee']").show()
      $("[data-display='fee'] input").prop "disabled", false
    $(document).on "change", "[data-calc='commission-split-type-radio']", ->
      if $(this).val() == "Percentage"
        $("[data-display='percentage']").show()
        $("[data-display='percentage'] input").prop "disabled", false
        $("[data-display='fee']").hide()
        $("[data-display='fee'] input").prop "disabled", true
      if $(this).val() == "Fee"
        $("[data-display='percentage']").hide()
        $("[data-display='percentage'] input").prop "disabled", true
        $("[data-display='fee']").show()
        $("[data-display='fee'] input").prop "disabled", false
      return
