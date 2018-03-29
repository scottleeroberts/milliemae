$(document).on 'turbolinks:load', ->
  $('#flatlay-selection').Jcrop({
    onChange: showCoords,
    onSelect: showCoords,
    boxWidth: 750
  })

showCoords = (c) ->
  $('#form-x1').val c.x
  $('#form-y1').val c.y
  $('#form-x2').val c.x2
  $('#form-y2').val c.y2
  $('#form-width').val c.w
  $('#form-height').val c.h
  return

