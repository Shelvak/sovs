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
  $(document).on 'change keyup', '.price-modifier', ->

    Sale.updateLinePrice $(this).parents('.product_line')

    Sale.updateTotalPrice()
