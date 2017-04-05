class PropertyInfo

  constructor: ->
    if $('[data="find-property-info"]').length
      $(document).on "click", '[data="find-property-info"]', (event) ->
        event.preventDefault()
        addressInfo = getAddressInfo()
        getPropertyInfoFrom(addressInfo)

  getAddressInfo = ->
    address = [
      $('[data-info="street"]').val(),
      $('[data-info="city"]').val(),
      $('[data-info="state"]').val(),
      $('[data-input-mask="zipcode"]').val()
    ].filter((v) ->
      v isnt ""
    ).join(' ')

    address

 getPropertyInfoFrom = (addressInfo) ->
  if !addressInfo.trim()
    alert 'Please fill the address first'
  else
    $('[data="find-property-info"]').prop('disabled', true)
    $('[data="find-property-info"]').html('Searching for property info..')

    $.ajax(
      url: '/leads/'+ $('[data-info=lead_id]').val() + '/properties/get_info_from_address.js?address_info=' + addressInfo
    )

document.addEventListener "turbolinks:load", ->
  #new PropertyInfo()
