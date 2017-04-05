class @ContactsGrader

  constructor: ->
    @initOnGradeBindings()

  initOnGradeBindings: ->
    $('[data-behaviour=contacts-grader]').bind "click", (event) ->
      event.preventDefault()
      contacts_table = $('#grading-and-graded-container')
      $.ajax
        url: $(this).data("grade-path")
        type: "POST"
        error: (data, status, xhr) ->
          alert "Error grading contact."
        success: (data, status, xhr) =>
          contacts_table.html(data)
          new ContactsDelete()
          new ContactsGrader()

      false
    @initSkipContactBinding()


  initSkipContactBinding: ->
    if $('#current_contact_id').length > 0
      contact_id = $('#current_contact_id').data('contact-id')
      if $('#skip_contact_link').length > 0
        rank_contact_path = $('#skip_contact_link').data('rank-contact-path')
        $('#skip_contact_link').attr('href', rank_contact_path+'?dont_rank='+contact_id)
    else
      if $('#skip_contact_link').length >1
        $('#skip_contact_link').remove()


document.addEventListener "turbolinks:load", ->
  new ContactsGrader()
