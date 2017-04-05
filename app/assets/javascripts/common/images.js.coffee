class @UploadImages

  console.log "Loading Upload Images Class"

  uploadFileLink: '[data-behavior=upload-file-link]'
  inputField:     '[data-behavior=attach-input-field]'
  profileImage:   '[data-behavior=profile-image-thumb]'
  hiddenInput:    '[data-behavior=attach-hidden-field]'

  constructor: ->
    @initFileUpload()
    @bindClickFileUploadLink()

  flashMessage: (msg) ->
    $('<div class="alert alert-error"><a class="close" data-dismiss="alert">×</a><div id="flash_error">' + msg + '</div></div>')

  bindClickFileUploadLink: ->
    $(document).on 'click', @uploadFileLink, ->
      $this = $(@)
      $this.siblings(@inputField).trigger('click')
      false

  initFileUpload: ->
    $(@inputField).fileupload
      type: 'POST'
      change: (e, data) ->
        $(".spinner-row").show()
      done: (e, data) =>
        $(".spinner-row").hide()
        response = jQuery.parseJSON(data.jqXHR.responseText)
        if response.errors
          alert(response.errors.file);
        else
          $(@profileImage).attr('style', 'background-image: url('+response.file.thumb.url+');')
          $(@hiddenInput).val(response.id)
          alert("Uploaded image successfully.");

        console.log(response)

document.addEventListener "turbolinks:load", ->
  window.uploadImages ||= new UploadImages()
