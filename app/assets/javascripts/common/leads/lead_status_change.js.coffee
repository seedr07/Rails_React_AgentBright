$(document).on 'click', 'a[data-behaviour=lead-status-dd-5], a[data-behaviour=lead-status-dd-6]', (event) ->
  event.preventDefault()
  lead_id = $(this).data('lead-id')
  console.log($(this))
  if $(this).data('behaviour') == "lead-status-dd-6"
    $('#lostModal'+lead_id).modal()
  else
    $('#pausedModal'+lead_id).modal()

  false

