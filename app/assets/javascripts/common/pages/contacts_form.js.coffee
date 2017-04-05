class @ContactsForm

  constructor: ->
    initGroupsTokenInputAutocomplete()

  initGroupsTokenInputAutocomplete: ->
    contactTagList = $("#contact_tag_list")
    if contactTagList.length
      $(window).keydown (event) ->
        code = event.keyCode or event.which
        if code is 13
          event.preventDefault()
          false

      contactTagList.tokenfield autocomplete:
        minLength: 2
        delay: 700
        source: contactTagList.data("source-url")

document.addEventListener "turbolinks:load", ->
  new ContactsForm()
