class @ContactsSearch

  constructor: ->

    # We want to wait for the user to stop typing for 1 second
    SEARCH_DELAY = 1000

    SearchUtils.configCheckBoxSelectAll('contacts-checkbox-select-all', 'contacts-container','contacts-delete-button')

    SearchUtils.configBtnGroup('contacts-btn-group-grade', doSearch)
    SearchUtils.configBtnGroup('contacts-btn-group-order-by', doSearch)
    SearchUtils.configBtnGroup('contact-btn-group', doSearch)
    SearchUtils.configSortDirBtn('contacts-sort-order-toggle', doSearch)

    configDeleteButton()
    configAjaxPaginationLinks()

    # here we will save the timeout id so we can cancel the search early
    #   if the user keeps on typing
    searchTimeoutId = null

    search_box = $('#contacts-search-input')
    search_box.data('search-url')
    search_box.bind 'input', (e, data) ->
      # First clear the old search timeout if it exists
      clearTimeout searchTimeoutId
      # Then set a new timeout to search the text box contents if the user
      # doesn't continue typing within 1 second
      searchTimeoutId = setTimeout doSearch, SEARCH_DELAY

  doSearch = ->
    search_box = $('#contacts-search-input')

    btn_group_grade = $('#contacts-btn-group-grade')
    btn_group_order_by = $('#contacts-btn-group-order-by')
    sort_order_toggle = $('#contacts-sort-order-toggle')
    contact_btn_group = $('#contact-btn-group')

    SearchUtils.resetMasterCheckbox('contacts-checkbox-select-all', 'contacts-delete-button')

    ajaxCall(search_box.data('search-url') + "?search_term=" + search_box.val() + "&order_by=" + btn_group_order_by.data('value') + "&sort_direction=" + sort_order_toggle.data('value') + "&grade=" + btn_group_grade.data('value') + "&group=" + contact_btn_group.data('value'))

  ajaxCall = (finalUrl) ->
    search_box = $('#contacts-search-input')
    contacts_table = $('#contacts-container')
    $.ajax
      url: finalUrl
      type: "GET"
      error: (data, status, xhr) ->
        # do nothing
      success: (data, status, xhr) =>
        contacts_table.html(data)
        configAjaxPaginationLinks()
        $('[data-toggle="popover"]').popover()

        SearchUtils.configContainerCheckBoxs('contacts-checkbox-select-all', 'contacts-container','contacts-delete-button')


  configDeleteButton = ->
    $("#contacts-delete-button").click (event) ->
      event.preventDefault()
      bootbox.confirm "Are you sure?", (result) ->
        if result
          deleteSelectedContacts()

  configAjaxPaginationLinks = ->
    $('#contacts-container').find(".pagination a").click (event) ->
      event.preventDefault()
      search_box = $('#contacts-search-input')
      finalUrl = search_box.data('search-url') + "?" + $(this).attr("href").split("?").slice(1)
      ajaxCall(finalUrl)

  deleteSelectedContacts = ->
    url = $("#contacts-delete-button").data('url')

    deleteIDs = $(".contact-search-item:checked").map(->
      $(this).val()
    ).get()

    $.ajax
      url: url
      type: "POST"
      data: JSON.stringify({ ids: deleteIDs }),
      contentType: "application/json; charset=utf-8",
      dataType: "json"
      error: (data, status, xhr) ->
        # do nothing
      success: (data, status, xhr) =>
        doSearch()

document.addEventListener "turbolinks:load", ->
  new ContactsSearch()
