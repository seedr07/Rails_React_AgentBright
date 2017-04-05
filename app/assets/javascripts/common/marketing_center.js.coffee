class @MarketingCenter

  constructor: ->
    mainMkTabContent = $("#main-mk-tab-content")
    if mainMkTabContent.length
      activeTab = sessionStorage.getItem("active-tab")
      if activeTab?
        $("#main-mk-tab a[href=\"#" + activeTab + "\"]").tab "show"
        sessionStorage.removeItem "active-tab"
      mainMkTabContent.find(".set-active-tab").click ->
        tabId = $(this).parents(".tab-pane").attr("id")
        sessionStorage.setItem "active-tab", tabId

document.addEventListener "turbolinks:load", ->
  new MarketingCenter()
