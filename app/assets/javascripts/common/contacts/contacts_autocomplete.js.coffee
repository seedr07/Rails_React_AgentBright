class @ContactsAutocomplete
  top_contacts_url = "/contacts/top_contact"
  constructor: ->
    @initContactAutocomplete()

  initContactAutocomplete: ->
    search_field     = $('#top_contact_search')
    autocomplete_url = $('#top_contact_search').data('autocomplete-source')

    numbers = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote: url:  autocomplete_url + '?search_term=%QUERY'
      wildcard: '%QUERY')

    numbers.initialize()

    search_field.typeahead null,
      name: 'top_contacts'
      limit: 10
      source: numbers.ttAdapter()
      templates:
        empty: [
          '<div class="empty-message">'
          'Unable to find any top contacts'
          '</div>'
        ].join('\n')
        suggestion: (data) ->
          '<p><a href=' + data.url + '>' + data.value + '</a></p>'

document.addEventListener "turbolinks:load", ->
  new ContactsAutocomplete()
