$(document).on 'turbolinks:load', ->
  setupFlatlayHotspots()
  $('.product-link-url').hover(showHighlight, hideHighlight)
  $('.flatlay-hotspot').hover(showHighlight, hideHighlight)
  $('#flatlay_image').hover(showHotspots, hideHotspots)
  $('.flatlay-hotspot').tooltip()

mobileDefaults = ->
  if isMobile()
    showHotspots()

isMobile = ->
  return ($('.display-hotspots').length is 1)

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
  mobileDefaults();

showHotspots =  ->
  $('.flatlay-hotspot').each( ->
    getFlatLayHotspot(@).css('background': 'rgb(255, 255, 255, 0.2)')
    getFlatLayHotspot(@).css('box-shadow', '10px 10px 20px -5px black')
    getFlatLayHotspot(@).visible()
  )

hideHotspots =  ->
  $('.flatlay-hotspot').each( -> getFlatLayHotspot(@).invisible() )
  mobileDefaults()

showHighlight =  ->
  getFlatLayHotspot(@).visible()
  getFlatLayHotspot(@).css('background', 'rgb(0, 0, 0, .2)')
  getFlatLayHotspot(@).css('box-shadow', '10px 10px 20px -5px white')
  getProductLinkUrl(@).addClass('url-highlight')

hideHighlight= ->
  getFlatLayHotspot(@).invisible()
  getProductLinkUrl(@).removeClass('url-highlight')
  mobileDefaults()

getProductLinkUrl = (flatlay_hotspot_element) ->
  product_link_id = $(flatlay_hotspot_element).data('productLinkId')
  $(".product-link-url[data-product-link-id='" + product_link_id + "']")

getFlatLayHotspot = (product_link_url_element) ->
   product_link_id = $(product_link_url_element).data('productLinkId')
   $(".flatlay-hotspot[data-product-link-id='" + product_link_id + "']")
