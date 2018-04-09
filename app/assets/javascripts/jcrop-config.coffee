$(document).on 'turbolinks:load', ->
  $(document).on 'click', '.js-toggle-product-link-form', (e) ->
    $('#flatlay-hotspot').Jcrop({
      onChange: saveCoordsToForm,
      onSelect: saveCoordsToForm,
      boxWidth: 750
    })
saveCoordsToForm = (c) ->
  $('#form-x1').val c.x
  $('#form-y1').val c.y
  $('#form-x2').val c.x2
  $('#form-y2').val c.y2
  $('#form-width').val c.w
  $('#form-height').val c.h
