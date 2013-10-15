new Rule
  load: ->
    # For browsers with no autofocus support
    $('[autofocus]:not([readonly]):not([disabled]):visible:first').focus()
    $('[data-show-tooltip]').tooltip()

    timers = @map.timers = []
    
    $('.alert[data-close-after]').each (i, a)->
      timers.push setTimeout((-> $(a).alert('close')), $(a).data('close-after'))

  unload: -> clearTimeout timer for i, timer of @map.timers

window.State =
  gain_changed: false

window.Message =
  quantity_to_put_in_stock: false

jQuery ($) ->
  $(document).on 'click', 'a.submit', -> $('form').submit(); false
  
  $(document).ajaxStart ->
    $('#loading_caption').stop(true, true).fadeIn(100)
  .ajaxStop ->
    $('#loading_caption').stop(true, true).fadeOut(100)
  
  $(document).on 'submit', 'form', ->
    $(this).find('input[type="submit"], input[name="utf8"]').attr 'disabled', true
    $(this).find('a.submit').removeClass('submit').addClass('disabled')
    $(this).find('.dropdown-toggle').addClass('disabled')

  $(document).keydown (e)->
    key = e.which
    root = window.location.origin

    # Ir a nueva venta
    if e.ctrlKey && e.altKey && (key == 54 || key == 86)
      e.preventDefault()
      window.location.href = root

    # Ir a productos
    if e.ctrlKey && e.altKey && (key == 48 || key == 80)
      e.preventDefault()
      window.location.href = "#{root}/products"

    # Focusear menu Otros
    if e.ctrlKey && e.altKey && (key == 47 || key == 79)
      e.preventDefault()
      $('.nav-collapse a.dropdown-toggle').focus().click()
      $('.dropdown-menu li:first a').focus()

    if (key == 37 || key == 38) && $(document.activeElement).parents('.nav').length
      e.preventDefault()
      $.emulateTab(-1)

    if (key == 39 || key == 40) && $(document.activeElement).parents('.nav').length
      e.preventDefault()
      $.emulateTab()

  $('a').on
    focusin: -> $(this).trigger('mouseover')
    focusout: -> $(this).trigger('mouseleave')

  Inspector.instance().load()


