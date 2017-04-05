class window.Salutation
  constructor: ->
    if $('#contact_letter_salutation').length or $('#contact_envelope_salutation').length
      formatLetterSaluation()
      formatEnvelopeSaluation()

      generate()

    editSalutations()

  generate =  ->
      $('#contact_first_name').on 'keyup', ->
        formatLetterSaluation()
        formatEnvelopeSaluation()
      $('#contact_last_name').on 'keyup', ->
        formatLetterSaluation()
        formatEnvelopeSaluation()
      $('#contact_spouse_first_name').on 'keyup', ->
        formatLetterSaluation()
        formatEnvelopeSaluation()
      $('#contact_spouse_last_name').on 'keyup', ->
        formatLetterSaluation()
        formatEnvelopeSaluation()

  formatLetterSaluation =  ->
    contactFirstName = $('#contact_first_name').val().trim()
    spouseFirstName  = $('#contact_spouse_first_name').val().trim()
    letterSalutation = ''

    if spouseFirstName && contactFirstName
      letterSalutation = "Dear #{contactFirstName} & #{spouseFirstName},"
    else
      if contactFirstName
        letterSalutation = "Dear #{contactFirstName},"

    $('#contact_letter_salutation').val(letterSalutation)

  formatEnvelopeSaluation = ->
    contactFirstName = $('#contact_first_name').val().trim()
    contactLastName  = $('#contact_last_name').val().trim()
    spouseFirstName  = $('#contact_spouse_first_name').val().trim()
    spouseLastName   = $('#contact_spouse_last_name').val().trim()
    envelopeSalutation = ''

    if spouseFirstName && contactFirstName && contactLastName
      if !spouseLastName or spouseLastName == contactLastName
        envelopeSalutation = "#{contactFirstName} & #{spouseFirstName} #{contactLastName},"
      else
        envelopeSalutation = "#{contactFirstName} #{contactLastName} & #{spouseFirstName} #{spouseLastName},"
    else
      if contactFirstName && contactLastName
        envelopeSalutation = "#{contactFirstName} #{contactLastName},"

    $('#contact_envelope_salutation').val(envelopeSalutation)

  editSalutations = ->
    $('#enable_salutation_field').click ->
      if $('#enable_salutation_field').is(':checked')
        $('#contact_envelope_salutation').prop('readonly', false);
        $('#contact_letter_salutation').prop('readonly', false);
      else
        $('#contact_envelope_salutation').prop('readonly', true);
        $('#contact_letter_salutation').prop('readonly', true);


document.addEventListener "turbolinks:load", ->
  new Salutation()
