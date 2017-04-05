class @LeadSettings

  constructor: ->
    divFormEditAbEmail = $('#div-form-edit-ab-email')
    linkEditAbEmail = $('#link-edit-ab-email')
    if(divFormEditAbEmail.find('.has-error').length == 0)
      divFormEditAbEmail.hide()
    else
      linkEditAbEmail.hide()

    linkEditAbEmail.click (event) ->
      divFormEditAbEmail.show()
      event.preventDefault()
      $(this).hide()

    $('#link-cancel-ab-email').click (event) ->
      event.preventDefault()
      linkEditAbEmail.show()
      divFormEditAbEmail.hide()

document.addEventListener "turbolinks:load", ->
  new LeadSettings()
