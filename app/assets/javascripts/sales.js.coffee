window.Sale =
  updateLinePrice: (product_line)->
    quantity = parseFloat product_line.find('input[name$="[quantity]"]').val()
    price = parseFloat product_line.find('input[name$="[price]"]').val()

    line_price = ((quantity || 0) * (price || 0)).toFixed(2)
    product_line.find('span.money').html("$ #{line_price}")
    product_line.attr('data-price', line_price)

  updateTotalPrice: () ->
    totalPrice = 0.0
    $('.product_line').each (i, element)->
      totalPrice += parseFloat($(this).attr('data-price')) || 0

    $('#sale_total_price').val(totalPrice.toFixed(2))


jQuery ($) ->
  if (add_nested = $('.btn.btn-small[data-dynamic-form-event="addNestedItem"]')).length > 0
    console.log('entro al nested')
    new_title = add_nested.attr('data-original-title') + ' (CTROL + ALT + A)'
    add_nested.attr('data-original-title', new_title)

    # Captura de atajos de teclado
    $(document).keydown (e)->
      key = e.which

      if (key == 65 || key == 97) && e.ctrlKey && e.altKey
        add_nested.click()
        e.preventDefault()

  $(document).on 'change keyup', '.price-modifier', ->
    Sale.updateLinePrice $(this).parents('.product_line')
    Sale.updateTotalPrice()

