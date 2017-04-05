class window.ProductionGoalsCalculator

  constructor: (@incomeGoal, @estBusinessExpenses, @agentSplit, @avgCommissionRate, @avgCommissionRateFee, @avgSalesPrice, @avgSalesPriceFee, @monthlyBrokerFeesPaid, @brokerFeePerTransaction, @franchiseFeePerTransaction) ->

  activeAvgCommissionRate: ->
    if $("[data-calc=commission-split-type-radio]:checked").val() == "Percentage"
      console.log "avgCommissionRate: percentage"
      @avgCommissionRate
    else
      console.log "avgCommissionRate: fee"
      @avgCommissionRateFee

  activeAvgSalesPrice: ->
    if $("[data-calc=commission-split-type-radio]:checked").val() == "Percentage"
      console.log "avgSalesPrice: percentage"
      @avgSalesPrice
    else
      console.log "avgSalesPrice: fee"
      @avgSalesPriceFee

  grossCommissionGoal: ->
    console.log("@incomeGoal: " + @incomeGoal)
    console.log("@totalExpenses " + @totalExpenses())
    console.log("@effFranchiseFeeRate " + @effFranchiseFeeRate())

    result = (@incomeGoal + @totalExpenses()) / @effFranchiseFeeRate()
    Math.round( result * 100)

  salesVolumeNeeded:->
    Math.round(@grossCommissionGoal() / @activeAvgCommissionRate() * 100)

  annualTransactionGoal: ->
    Math.ceil(@salesVolumeNeeded() / @activeAvgSalesPrice())

  quarterlyTransactionGoal: ->
    Math.ceil(@annualTransactionGoal()/4)

  monthlyTransactionGoal: ->
    Math.ceil(@annualTransactionGoal()/12)

  totalExpenses: ->
    @estBusinessExpenses + ((@monthlyBrokerFeesPaid || 0) * 12)

  avgGrossCommission: ->
    (@activeAvgCommissionRate() * @activeAvgSalesPrice()) / 100

  effFeeRate: ->
    result = 1 - @brokerFeePerTransaction / @avgGrossCommission()
    @toFloat(result * 100)

  effPrecentageRate: ->
    console.log("@agentSplit: " + @agentSplit)
    @agentSplit

  effFranchiseFeeRate: ->
    result = ""
    if $("[data-calc=franchise-fee-radio]:checked").val() == "true"
      if $("[data-calc=commission-split-type-radio]:checked").val() == "Percentage"
        result = (1 - @franchiseFeePerTransaction / 100 ) * @agentSplit
        return @toFloat(result)
      if $("[data-calc=commission-split-type-radio]:checked").val() == "Fee"
        result = ((@avgGrossCommission() * (1 - @franchiseFeePerTransaction / 100) - @brokerFeePerTransaction) / @avgGrossCommission()) * 100
        return @toFloat(result)

    if $("[data-calc=franchise-fee-radio]:checked").val() == "false"
      if $("[data-calc=commission-split-type-radio]:checked").val() == "Percentage"
        console.log("@effPrecentageRate(): " + @effPrecentageRate())
        return @effPrecentageRate()
      if $("[data-calc=commission-split-type-radio]:checked").val() == "Fee"
        return @effFeeRate()

  toFloat: (value) ->
    parseFloat(value)
