$(document).on 'turbolinks:load', ->
  setupFlatlaySelections()
  $('.product-link-url').hover(showSelectionBox, hideSelectionBox)
  $('.flatlay-selection').hover(showUrlHighlight, hideUrlHighlight)

setupFlatlaySelections = ->
  $('.product-link-url').each( ->
    flatlay_selection_id = $(@).data('productLinkId')
    flatlay_selection = $(".flatlay-selection[data-product-link-id='" + flatlay_selection_id + "']")
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
  flatlay_selection_id = $(@).data('productLinkId')
  flatlay_selection = $(".flatlay-selection[data-product-link-id='" + flatlay_selection_id + "']")

  flatlay_selection.visible()

hideSelectionBox = ->
  flatlay_selection_id = $(@).data('productLinkId')
  flatlay_selection = $(".flatlay-selection[data-product-link-id='" + flatlay_selection_id + "']")
  flatlay_selection.invisible()

showUrlHighlight =  ->
  product_link_id = $(this).data('productLinkId')
  product_link_url = $(".product-link-url[data-product-link-id='" + product_link_id + "']")
  product_link_url.addClass('url-highlight')
  showSelectionBox()

hideUrlHighlight = ->
  product_link_id = $(this).data('productLinkId')
  product_link_url = $(".product-link-url[data-product-link-id='" + product_link_id + "']")
  product_link_url.removeClass('url-highlight')
  hideSelectionBox()



