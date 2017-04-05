class CommentForm
  constructor: ->
    if $("[data-behavior=\"submit_comment\"]").length
      @submitOnEnter()

  submitOnEnter: ->
    $("[data-behavior=\"submit_comment\"]").keypress (e) ->
      if e.keyCode is 13 and not e.shiftKey
        e.preventDefault()
        $(this).closest("form").submit()
      return
    return

document.addEventListener "turbolinks:load", ->
  new CommentForm()

