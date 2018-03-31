$(document).on 'turbolinks:load', ->
  $('#flatlay-selection').Jcrop({
    onChange: showCoords,
    onSelect: showCoords,
    boxWidth: 750
  })

  $('.pl_link').hover(showSelectionBox, hideSelectionBox)

showCoords = (c) ->
  $('#form-x1').val c.x
  $('#form-y1').val c.y
  $('#form-x2').val c.x2
  $('#form-y2').val c.y2
  $('#form-width').val c.w
  $('#form-height').val c.h

showSelectionBox =  ->
  pl_selection = $('#' + $(@).attr('pl_link_id'))

  left = pl_selection.data('left')
  top = pl_selection.data('top')
  width = pl_selection.data('width')
  height = pl_selection.data('height')

  pl_selection.css('left', "#{left}%")
  pl_selection.css('top', "#{top}%")
  pl_selection.css('width', "#{width}%")
  pl_selection.css('height', "#{height}%")
  pl_selection.show()

hideSelectionBox = ->
  pl_selection = $('#' + $(@).attr('pl_link_id'))
  pl_selection.hide()

