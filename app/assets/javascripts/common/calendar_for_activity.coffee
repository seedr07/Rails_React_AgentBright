class CalendarForActivity
  constructor: ->
    selector = '.activity_dashboard [data-behavior~=activity-datepicker]'
    $datepicker = $(selector)
    $datepicker.datepicker
      dateFormat: 'yy-mm-dd'
      onSelect: (o) ->
        window.location = window.location.pathname + '?date=' + o

    $('#calendar-selector').click ->
      $datepicker.datepicker "show"

document.addEventListener "turbolinks:load", ->
  new CalendarForActivity
