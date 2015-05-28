# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('div.document').each ->
    $(this).zoom url: $('img', this).data('big')
    return

  $('input.document-tags').tagEditor
    placeholder: 'Enter tags ...',
    autocomplete: { 'source': '/tags/autocomplete', minLength: 3 }
  return
