$(document).on 'turbolinks:load', ->
  setupFlatlayHotspots()
  $('.product-link-url').hover(showHighlight, hideHighlight)
  $('.flatlay-hotspot').hover(showHighlight, hideHighlight)



setupFlatlayHotspots = ->
  $('.product-link-url').each( ->
    flatlay_hotspot = getFlatLayHotspot(@)

    left = flatlay_hotspot.data('left')
    top = flatlay_hotspot.data('top')
    width = flatlay_hotspot.data('width')
    height = flatlay_hotspot.data('height')

    flatlay_hotspot.invisible()
    flatlay_hotspot.css('left', "#{left}%")
    flatlay_hotspot.css('top', "#{top}%")
    flatlay_hotspot.css('width', "#{width}%")
    flatlay_hotspot.css('height', "#{height}%")
  )

showHighlight =  ->
  getFlatLayHotspot(@).visible()
  getProductLinkUrl(@).addClass('url-highlight')

hideHighlight= ->
  getFlatLayHotspot(@).invisible()
  getProductLinkUrl(@).removeClass('url-highlight')

getProductLinkUrl = (flatlay_hotspot_element) ->
  product_link_id = $(flatlay_hotspot_element).data('productLinkId')
  $(".product-link-url[data-product-link-id='" + product_link_id + "']")

getFlatLayHotspot = (product_link_url_element) ->
   product_link_id = $(product_link_url_element).data('productLinkId')
   $(".flatlay-hotspot[data-product-link-id='" + product_link_id + "']")
