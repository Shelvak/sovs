new Rule
  load: ->
    # For browsers with no autofocus support
    $('[autofocus]:not([readonly]):not([disabled]):visible:first').focus()
    $('input:visible:not(.date_picker):not(.datetime_picker):first').focus()
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
      $('.nav a.dropdown-toggle').focus().click()
      $('.dropdown-menu li:first a').focus()

    # Flechas izq & arriba == ShiftTAB
    if (key == 37 || key == 38) && $(document.activeElement).parents('.nav').length
      e.preventDefault()
      $.emulateTab(-1)

    # Flechas der & abajo == TAB
    if (key == 39 || key == 40) && $(document.activeElement).parents('.nav').length
      e.preventDefault()
      $.emulateTab()

    # Click en Nuevo
    if e.ctrlKey && e.altKey && (key == 46 || key == 78)
      e.preventDefault()
      href = $('.form-actions .btn.btn-primary').attr('href')

      if href && href.match(/new$/)
        window.location.href = href

    # Imprimir resumen diario
    if e.ctrlKey && e.altKey && (key == 68 || key == 100)
      e.preventDefault()
      date = new Date
      day = [date.getFullYear(), (date.getMonth()+1), date.getDate()].join('-')
      path = "daily_boxes/print_daily_report?date=#{day}"

      $.ajax
        url: [root, path].join('/')
        dataType: 'json'
        type: 'put'

      setTimeout((-> location.reload()), 3000)

    # Ir a lista de proveedores
    if e.ctrlKey && e.altKey && (key == 76 || key == 108)
      e.preventDefault()
      window.location = $('[data-list-for-print]').attr('href')

  $('a').on
    focusin: -> $(this).trigger('mouseover')
    focusout: -> $(this).trigger('mouseleave')


  $(document).on 'click', 'a.js-change-seller', (e) ->
    e.preventDefault()

    link = $(this)

    seller = prompt(link.data('confirmMsg'))

    if seller
      $.ajax
        url: '/sellers/assign_current'
        type: 'put'
        data: { current_seller: seller }
        dataType: 'json'

  Inspector.instance().load()


