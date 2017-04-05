class @LeadsSearch

  constructor: ->

    SearchUtils.configCheckBoxSelectAll('leads-checkbox-select-all', 'leads-container','leads-delete-button')

    SearchUtils.configBtnGroup('leads-btn-group-status', doSearch)
    SearchUtils.configBtnGroup('leads-btn-group-order-by', doSearch)
    configDeleteButton()
    configAjaxPaginationLinks()

    search_box = $('#leads-search-input')
    search_box.data('search-url')
    search_box.bind 'input', (e, data) ->
      doSearch()

    SearchUtils.configSortDirBtn('leads-sort-order-toggle', doSearch)

  configDeleteButton = ->
    $("#leads-delete-button").click (event) ->
      event.preventDefault()
      bootbox.confirm "Are you sure?", (result) ->
        if result
          deleteSelectedLeads()

  deleteSelectedLeads = ->
    url = $("#leads-delete-button").data('url')
    deleteIDs = $(".lead-search-item:checked").map(->
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

  doSearch = ->
    finalUrl = generateSearchUrl()
    ajaxCall(finalUrl)

  generateSearchUrl = ->
    search_box = $('#leads-search-input')
    btn_group_status = $('#leads-btn-group-status')
    btn_group_order_by = $('#leads-btn-group-order-by')
    sort_order_toggle = $('#leads-sort-order-toggle')

    return search_box.data('search-url') + "?search_term=" + search_box.val() + "&status=" + btn_group_status.data('value') + "&order_by=" + btn_group_order_by.data('value') + "&sort_direction=" + sort_order_toggle.data('value') + "&action_name=" + search_box.data('action-name')

  ajaxCall = (finalUrl) ->
    contacts_table = $('#leads-container')
    SearchUtils.resetMasterCheckbox('leads-checkbox-select-all', 'leads-delete-button')
    $.ajax
      url: finalUrl
      type: "GET"
      error: (data, status, xhr) ->
        # do nothing
      success: (data, status, xhr) =>
        contacts_table.html(data)
        showNoRecordsFoundByStatus()
        configAjaxPaginationLinks();

        SearchUtils.configContainerCheckBoxs('leads-checkbox-select-all', 'leads-container','leads-delete-button')

  showNoRecordsFoundByStatus = ->
    no_records_client_text = $('#no-records-client-text')
    if no_records_client_text.length == 1
      not_found_text = $('#leads-btn-group-status').find('li.active').find('a').data('not-found-text')
      no_records_client_text.text(not_found_text) if not_found_text != undefined

  configAjaxPaginationLinks = ->
    $('#leads-container').find(".pagination a").click (event) ->
      event.preventDefault()
      search_box = $('#leads-search-input')
      page_number = SearchUtils.getUrlParameterByName($(this).attr("href"),"page")
      finalUrl = generateSearchUrl() + "&page=" + page_number
      ajaxCall(finalUrl)

document.addEventListener "turbolinks:load", ->
  new LeadsSearch()
