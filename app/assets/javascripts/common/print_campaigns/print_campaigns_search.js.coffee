class @PrintCampaignsSearch

  constructor: ->

    SearchUtils.configCheckBoxSelectAll('print-campaigns-checkbox-select-all', 'print-campaigns-container','print-campaigns-delete-button')

    SearchUtils.configBtnGroup('print-campaigns-btn-group-campaign-status', doSearch)
    SearchUtils.configBtnGroup('print-campaigns-btn-group-order-by', doSearch)
    SearchUtils.configBtnGroup('print-campaign-btn-group', doSearch)
    SearchUtils.configSortDirBtn('print-campaigns-sort-order-toggle', doSearch)

    configDeleteButton()
    configAjaxPaginationLinks()

    search_box = $('#print-campaigns-search-input')
    search_box.data('search-url')
    search_box.bind 'input', (e, data) ->
      doSearch()


  doSearch = ->
    search_box = $('#print-campaigns-search-input')
    btn_group_campaign_status = $('#print-campaigns-btn-group-campaign-status')
    btn_group_order_by = $('#print-campaigns-btn-group-order-by')
    sort_order_toggle = $('#print-campaigns-sort-order-toggle')

    SearchUtils.resetMasterCheckbox('print-campaigns-checkbox-select-all', 'print-campaigns-delete-button')

    ajaxCall(search_box.data('search-url') + "?search_term=" + search_box.val() + "&order_by=" + btn_group_order_by.data('value') + "&sort_direction=" + sort_order_toggle.data('value') + "&printed=" + btn_group_campaign_status.data('value') )

  ajaxCall = (finalUrl) ->
    search_box = $('#print-campaigns-search-input')
    print_campaigns_table = $('#print-campaigns-container')
    $.ajax
      url: finalUrl
      type: "GET"
      error: (data, status, xhr) ->
        # do nothing
      success: (data, status, xhr) =>
        print_campaigns_table.html(data)
        configAjaxPaginationLinks()
        $('[data-toggle="popover"]').popover()

        SearchUtils.configContainerCheckBoxs('print-campaigns-checkbox-select-all', 'print-campaigns-container','print-campaigns-delete-button')


  configDeleteButton = ->
    $("#print-campaigns-delete-button").click (event) ->
      event.preventDefault()
      bootbox.confirm "Are you sure?", (result) ->
        if result
          deleteSelectedPrintCampaigns()

  configAjaxPaginationLinks = ->
    $('#print-campaigns-container').find(".pagination a").click (event) ->
      event.preventDefault()
      search_box = $('#print-campaigns-search-input')
      finalUrl = search_box.data('search-url') + "?" + $(this).attr("href").split("?").slice(1)
      ajaxCall(finalUrl)

  deleteSelectedPrintCampaigns = ->
    url = $("#print-campaigns-delete-button").data('url')

    deleteIDs = $(".print-campaign-search-item:checked").map(->
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
  new PrintCampaignsSearch()
