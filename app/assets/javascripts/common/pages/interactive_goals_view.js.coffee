class window.InteractiveGoalsView

  inputMapping: {}
  changeMapping: {}
  resultMapping: {}
  autoNumericOptions: {vMax: Infinity , mDec: '0'}

  constructor: ->
    for variable in Object.keys(@inputMapping)
      @[variable] = null
      @[variable + "Input"] = @inputMapping[variable]

    for variable in Object.keys(@resultMapping)
      @[variable] = null
      @[variable + "Input"] = @resultMapping[variable]

    for variable in Object.keys(@changeMapping)
      @[variable] = null
      @[variable + "Input"] = @changeMapping[variable]
    @mapEvents()
    @mapChanges()

  mapEvents: =>
    for variable in Object.keys(@inputMapping)
      input = @[variable + "Input"]
      $(input).on 'keyup', @render

  mapChanges: =>
    for variable in Object.keys(@changeMapping)
      input = @[variable + "Input"]
      $(input).on "change", @render

  render: =>
    @getValues()
    if @valid()
      @calculate()
      @setValues()
    @

  getValues: =>
    for variable in Object.keys(@inputMapping)
      input = @[variable + "Input"]
      @[variable] = parseFloat $(input).val().replace(/,/g, '')

  setValues: =>
    for variable in Object.keys(@resultMapping)
      input = @[variable + "Input"]
      value = @[variable]
      value = '' if isNaN(value)
      $(input).val(value)

  valid: =>
    true

  validNumbers: ->
    result = true
    for arg in arguments
      result &&= !isNaN(arg)
    result

  calculate: =>
