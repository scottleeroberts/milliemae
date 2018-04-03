$(document).on 'turbolinks:load', ->
  $('.card-topper').hover(showLayflat, showShowcase)

showLayflat = ->
  $(@).css({'background-image': "url(#{$(@).data('layflatImage')})"})
  true

showShowcase = ->
  $(@).css({'background-image': "url(#{$(@).data('showcaseImage')})"})
  true

