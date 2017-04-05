class @SearchUtils
  self = this

  @configContainerCheckBoxs: (masterCheckboxId, containerId, deleteButtonId) ->
    masterCheckbox = $('#' + masterCheckboxId)
    container = $('#' + containerId)

    container.find('.item-checkbox').bind "click touchstart", (event) ->
      self.checkStatus(masterCheckboxId, containerId, deleteButtonId)

  @resetMasterCheckbox: (masterCheckboxId, deleteButtonId) ->
    masterCheckbox = $('#' + masterCheckboxId)
    masterCheckbox.prop('checked', false)
    $('#' + deleteButtonId).hide();

  @configCheckBoxSelectAll: (masterCheckboxId, containerId, deleteButtonId) ->
    masterCheckbox = $('#' + masterCheckboxId)
    container = $('#' + containerId)
    deleteButton = $('#' + deleteButtonId)
    deleteButton.hide();

    @configContainerCheckBoxs(masterCheckboxId, containerId, deleteButtonId)
    masterCheckbox.bind "click touchstart", (event) ->
      if masterCheckbox.is(':checked')
        checkBoxItems = container.find('.item-checkbox')
        deleteButton.show()
        checkBoxItems.prop('checked', true)
      else
        checkBoxItems = container.find('.item-checkbox')
        deleteButton.hide()
        checkBoxItems.prop('checked', false)

      self.checkStatus(masterCheckboxId, containerId, deleteButtonId)

  @checkStatus: (masterCheckboxId, containerId, deleteButtonId) ->
    masterCheckbox = $('#' + masterCheckboxId)
    masterCheckboxIsChecked = masterCheckbox.prop('checked')
    container = $('#' + containerId)
    deleteButton = $('#' + deleteButtonId)
    allCheckboxesCount = container.find('.item-checkbox').length
    checkedCount = container.find('.item-checkbox:checked').length

    if checkedCount > 0
      deleteButton.show()
    else
      deleteButton.hide()

    if checkedCount == allCheckboxesCount
      if not masterCheckboxIsChecked
        masterCheckbox.prop('checked', true)
    else
      if masterCheckboxIsChecked
        masterCheckbox.prop('checked', false)

  @configBtnGroup = (btnGroupId, callback) ->
    $("#" + btnGroupId).find(".dropdown-menu a").click (event) ->
      event.preventDefault()
      link = $(this)
      btnGroup = link.parents(".btn-group")
      link.parents(".dropdown-menu").find("li").removeClass "active"
      link.parent().addClass "active"
      btnGroup.find(".btn-group-button-text").text $(this).text()
      btnGroup.data "value", link.data("value")
      callback()

  @configSortDirBtn = (btnSortId, callback) ->
    $("#" + btnSortId).click (event) ->
      event.preventDefault()
      button = $(this)
      if button.data("value") is "desc"
        button.data "value", "asc"
        button.find("span:first").removeClass("glyphicon-arrow-up").addClass "glyphicon-arrow-down"
      else
        button.data "value", "desc"
        button.find("span:first").removeClass("glyphicon-arrow-down").addClass "glyphicon-arrow-up"

      callback()

  @getUrlParameterByName = (base_url, name) ->
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
    results = regex.exec(base_url)
    (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))
