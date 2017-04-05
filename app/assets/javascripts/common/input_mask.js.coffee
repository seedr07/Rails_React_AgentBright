# Requires jquery.inputmask

class window.InputMask
  constructor: ->
    formattedIntegerInputMask()
    currencyInputMask()
    phoneNumberInputMask()
    zipCodeInputMask()
    oneDecimalPercentageInputMask()
    twoDecimalPercentageInputMask()

  integerInputOptions = ->
    options =
      groupSeparator: ","
      autoGroup: true
      allowPlus: false
      allowMinus: false
      removeMaskOnSubmit: true

    return options

  formattedIntegerInputMask = ->
    integerInputSelectors = $('[data-input-mask="formatted-integer"]')

    if integerInputSelectors.length
      integerInputSelectors.each ->
        handleIntegerInputMask(this, integerInputOptions())

  currencyInputMask =  ->
    currencySelectors = $('[data-input-mask="currency"]')

    if currencySelectors.length
      currencySelectors.each ->
        handleIntegerInputMask(this, integerInputOptions())

  phoneNumberInputMask = ->
    phoneSelectors = $('[data-input-mask="phone"]')

    if phoneSelectors.length
      options = { mask: "(999) 999-9999 [x9999]",
      skipOptionalPartCharacter: "#", greedy: false,
      showMaskOnHover: true, showMaskOnFocus: true }

      phoneSelectors.each ->
        $(this).inputmask(options)

  zipCodeInputMask = ->
    zipCodeSelectors = $('[data-input-mask="zipcode"]')

    if zipCodeSelectors.length
      options = { mask: "99999[-9999]",
      skipOptionalPartCharacter: "#", greedy: false,
      showMaskOnHover: true, showMaskOnFocus: true }

      zipCodeSelectors.each ->
        $(this).inputmask(options)

  oneDecimalPercentageInputMask = ->
    oneDecimalPercentageSelectors = $('[data-input-mask="onedecimal_percentage"]')

    if oneDecimalPercentageSelectors.length
      oneDecimalPercentageSelectors.each ->
        $(this).on "input", (event) ->
          input_value = $(this).val()
          n = parseFloat(input_value)

          if n > 100
            $(this).val('')
            return
          else if validateOneDecimalPercentage(input_value)
            return
          else
            $(this).val(input_value.slice(0,-1))

        $(this).on "blur", (event) ->
          input_value = $(this).val()
          if input_value
            new_value = input_value.replace(/\.$/, "")
            new_value = new_value.replace(/^0+/, "")

            new_value = parseFloat(new_value).toFixed(1)

            new_value = "" if isNaN(new_value)

            $(this).val(new_value)

  twoDecimalPercentageInputMask = ->
    twoDecimalPercentageSelectors = $('[data-input-mask="twodecimal_percentage"]')

    if twoDecimalPercentageSelectors.length
      twoDecimalPercentageSelectors.each ->
        $(this).on "input", (event) ->
          input_value = $(this).val();
          n = parseFloat(input_value)

          if n > 100
            $(this).val('')
            return
          else if validateTwoDecimalPercentage(input_value)
            return
          else
            $(this).val(input_value.slice(0,-1))

        $(this).on "blur", (event) ->
          input_value = $(this).val()
          if input_value
            new_value = input_value.replace(/\.$/, "")
            new_value = new_value.replace(/^0+/, "")

            new_value = parseFloat(new_value).toFixed(2)

            new_value = "" if isNaN(new_value)

            $(this).val(new_value)

  validateOneDecimalPercentage = (x) ->
    validatePercentage(x, 1)

  validateTwoDecimalPercentage = (x) ->
    validatePercentage(x, 2)

  validatePercentage = (x, decimal_size) ->
    return true if x == "."

    parts = x.split(".")
    return false  if (parts[1] != "" and (typeof parts[1] is "string") and (parts[1].length > decimal_size))

    n = parseFloat(x)
    return false  if isNaN(n)

    return false  if n < 0 or n > 100
    true


  removeDecimal = (value) ->
    Math.ceil(value)

  handleIntegerInputMask = (selector, options) ->
    processedValue = removeDecimal($(selector).val())
    $(selector).val(processedValue) if processedValue

    $(selector).inputmask("integer", options)


document.addEventListener "turbolinks:load", ->
  new InputMask()
