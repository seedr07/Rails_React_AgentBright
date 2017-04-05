class window.ActivityGoalsCalculator

  constructor: (@referralsNeededPerClosedSale, @communicationsNeededPerReferral, @monthlyTransactionGoal) ->
    @avgWeeksInMonth = 4.16

  referralsNeededPerMonth: ->
    @referralsNeededPerClosedSale * @monthlyTransactionGoal

  communicationsNeededPerMonth: ->
    @referralsNeededPerMonth() * @communicationsNeededPerReferral

# Weekly Effort Calculation
  suggestedTotalWeeklyEffort: ->
    Math.ceil(@communicationsNeededPerMonth()/@avgWeeksInMonth)

  suggestedCallsNeededPerWeek: ->
    Math.ceil(@suggestedTotalWeeklyEffort() * 0.35)

  suggestedNoteRequiredPerWeek: ->
    Math.ceil(@suggestedTotalWeeklyEffort() * 0.50)

  suggestedVisitsRequiredPerWeek: ->
    Math.ceil(@suggestedTotalWeeklyEffort() * 0.15)

# Daily Effort Calculation

  suggestedTotalDailyEffort: ->
    Math.ceil(@suggestedTotalWeeklyEffort() / 4)

  suggestedCallsNeededPerDay: ->
    Math.ceil(@suggestedCallsNeededPerWeek() / 4)

  suggestedNoteRequiredPerDay: ->
    Math.ceil(@suggestedNoteRequiredPerWeek() / 4)

  suggestedVisitsRequiredPerDay: ->
    Math.ceil(@suggestedVisitsRequiredPerWeek() / 4)