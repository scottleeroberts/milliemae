$(document).on 'turbolinks:load', ->
  preload( imagesToPreload() )
  $('.card-topper').hover(showLayflat, showShowcase)

showLayflat = ->
  $(@).css({'background-image': "url(#{$(@).data('layflatImage')})"})
  true

showShowcase = ->
  $(@).css({'background-image': "url(#{$(@).data('showcaseImage')})"})
  true


imagesToPreload = ->
  elements = document.getElementsByClassName('card-topper')
  vals = []
  i = 0
  while typeof elements[i] != 'undefined'
    vals.push elements[i++].getAttribute('data-layflat-image')
  return vals

preload = (arrayOfImages) ->
  $(arrayOfImages).each ->
    $('<img/>')[0].src = this
    return
  return
