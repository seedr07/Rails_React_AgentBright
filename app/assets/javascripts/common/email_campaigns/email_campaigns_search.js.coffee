class @EmailCampaignsSearch

  constructor: ->

    SearchUtils.configCheckBoxSelectAll('email-campaigns-checkbox-select-all', 'email-campaigns-container','email-campaigns-delete-button')

    SearchUtils.configBtnGroup('email-campaigns-btn-group-campaign-status', doSearch)
    SearchUtils.configBtnGroup('email-campaigns-btn-group-order-by', doSearch)
    SearchUtils.configBtnGroup('email-campaign-btn-group', doSearch)
    SearchUtils.configSortDirBtn('email-campaigns-sort-order-toggle', doSearch)

    configDeleteButton()
    configAjaxPaginationLinks()

    search_box = $('#email-campaigns-search-input')
    search_box.data('search-url')
    search_box.bind 'input', (e, data) ->
      doSearch()


  doSearch = ->
    search_box = $('#email-campaigns-search-input')
    btn_group_campaign_status = $('#email-campaigns-btn-group-campaign-status')
    btn_group_order_by = $('#email-campaigns-btn-group-order-by')
    sort_order_toggle = $('#email-campaigns-sort-order-toggle')

    SearchUtils.resetMasterCheckbox('email-campaigns-checkbox-select-all', 'email-campaigns-delete-button')

    ajaxCall(search_box.data('search-url') + "?search_term=" + search_box.val() + "&order_by=" + btn_group_order_by.data('value') + "&sort_direction=" + sort_order_toggle.data('value') + "&campaign_status=" + btn_group_campaign_status.data('value') )

  ajaxCall = (finalUrl) ->
    search_box = $('#email-campaigns-search-input')
    email_campaigns_table = $('#email-campaigns-container')
    $.ajax
      url: finalUrl
      type: "GET"
      error: (data, status, xhr) ->
        # do nothing
      success: (data, status, xhr) =>
        email_campaigns_table.html(data)
        configAjaxPaginationLinks()
        $('[data-toggle="popover"]').popover()

        SearchUtils.configContainerCheckBoxs('email-campaigns-checkbox-select-all', 'email-campaigns-container','email-campaigns-delete-button')


  configDeleteButton = ->
    $("#email-campaigns-delete-button").click (event) ->
      event.preventDefault()
      bootbox.confirm "Are you sure?", (result) ->
        if result
          deleteSelectedEmailCampaigns()

  configAjaxPaginationLinks = ->
    $('#email-campaigns-container').find(".pagination a").click (event) ->
      event.preventDefault()
      search_box = $('#email-campaigns-search-input')
      finalUrl = search_box.data('search-url') + "?" + $(this).attr("href").split("?").slice(1)
      ajaxCall(finalUrl)

  deleteSelectedEmailCampaigns = ->
    url = $("#email-campaigns-delete-button").data('url')

    deleteIDs = $(".email-campaign-search-item:checked").map(->
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
  new EmailCampaignsSearch()
