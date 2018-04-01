$(document).on 'turbolinks:load', ->
  setupFlatlaySelections()
  $('.product-link-url').hover(showSelectionBox, hideSelectionBox)
  $('.flatlay-selection').hover(showUrlHighlight, hideUrlHighlight)



setupFlatlaySelections = ->
  $('.product-link-url').each( ->
    flatlay_selection = getFlatLaySelection(@)

    left = flatlay_selection.data('left')
    top = flatlay_selection.data('top')
    width = flatlay_selection.data('width')
    height = flatlay_selection.data('height')

    flatlay_selection.invisible()
    flatlay_selection.css('left', "#{left}%")
    flatlay_selection.css('top', "#{top}%")
    flatlay_selection.css('width', "#{width}%")
    flatlay_selection.css('height', "#{height}%")
  )

showSelectionBox =  ->
  getFlatLaySelection(@).visible()

hideSelectionBox = ->
  getFlatLaySelection(@).invisible()

showUrlHighlight =  ->
  getProductLinkUrl(@).addClass('url-highlight')
  getFlatLaySelection(@).visible()

hideUrlHighlight = ->
  getProductLinkUrl(@).removeClass('url-highlight')
  getFlatLaySelection(@).invisible()

getProductLinkUrl = (flatlay_selection_element) ->
  product_link_id = $(flatlay_selection_element).data('productLinkId')
  $(".product-link-url[data-product-link-id='" + product_link_id + "']")

getFlatLaySelection = (product_link_url_element) ->
   product_link_id = $(product_link_url_element).data('productLinkId')
   $(".flatlay-selection[data-product-link-id='" + product_link_id + "']")
