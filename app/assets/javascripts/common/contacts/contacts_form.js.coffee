class @ContactsForm

  constructor: ->
    @initGroupsTokenInputAutocomplete()

  initGroupsTokenInputAutocomplete: ->
    contactTagList = $("#contact_tag_list")
    contactGroupTagList = $("#contact_group_tag_list")
    testContactTagList = $("#test_contact_tag_list")
    if contactTagList.length
      $(window).keydown (event) ->
        code = event.keyCode or event.which
        if code is 13
          event.preventDefault()
          false
      defaultTagList = contactTagList.data('default-tag-list').split(',')
      data = getData(defaultTagList)
      contactTagList.select2({multiple: true, data: data})

    if contactGroupTagList.length
      $(window).keydown (event) ->
        code = event.keyCode or event.which
        if code is 13
          event.preventDefault()
          false
      defaultTagList = contactGroupTagList.data('default-tag-list').split(',')
      contactGroupTagList.select2({tags: defaultTagList, maximumInputLength: 0});
    if testContactTagList.length
      $(window).keydown (event) ->
        code = event.keyCode or event.which
        if code is 13
          event.preventDefault()
          false
      defaultTagList = testContactTagList.data('default-tag-list').split(',')
      testContactTagList.select2({tags: defaultTagList, maximumInputLength: 0});

  getData = (list) ->
    data = []
    $.each list, (index, tag) ->
      data.push({ id: tag, text: tag })
    data

document.addEventListener "turbolinks:load", ->
  new ContactsForm()

document.addEventListener "turbolinks:load", ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))

    $newFieldset = $(this).parent().find("fieldset").last()
    fieldToValidate = $newFieldset.find('[data-behavior=validate]').attr("name")
    $('[data-behavior=form-validation]').formValidation('addField', fieldToValidate)

    new InputMask() # This will hookup input mask for phone number

    event.preventDefault()
