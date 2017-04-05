class @ContactsDelete

  constructor: ->
    @initOnDeleteBindings()

  initOnDeleteBindings: ->
    $("a[data-remote]#contact-delete").on "ajax:success", (e, data, status, xhr) ->
      contacts_table = $('#grading-and-graded-container')
      console.log(contacts_table)
      alert "Contact successfully deleted."
      contacts_table.html(data)
      new ContactsDelete()
      new ContactsGrader()

document.addEventListener "turbolinks:load", ->
  new ContactsDelete()
