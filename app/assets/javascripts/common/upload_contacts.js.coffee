# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require common/vendor/jquery.customfileinput

extractExtention = (filename) ->
  dot = filename.lastIndexOf(".");
  return null if dot == -1
  return filename.substr(dot, filename.length).toLowerCase();


document.addEventListener "turbolinks:load", ->
  form = $("form[data-behavior=upload-contacts]")
  input = $("input[type=file]", form)

  input.customFileInput()

  form.submit ->
    filename = input.val()

    if filename.length == 0
      $(".btn-loading").button("reset")
      alert("Please select a file")
      return false

    if extractExtention(filename) != ".csv"
      $(".btn-loading").button("reset")
      alert("Please select a file with extension .csv")
      return false
