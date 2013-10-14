window.TransferProduct =
  recalcLineTotal: (transferLine)->
    price = parseFloat(
      transferLine.find('[data-iva-cost]').html().match(/\d+[,|.]\d+/)[0]
    )
    quantity = parseFloat(
      transferLine.find('input[name$="[quantity]"]').val()
    )
    symbol = transferLine.find('[data-total-price]').html().match(/(^\D+)/)[0]
  
    totalLinePrice = parseFloat((price || 0) * (quantity || 0)).toFixed(2)
  
    transferLine.find('[data-total-price]').html(symbol + totalLinePrice)
    transferLine.data('price', totalLinePrice)

  calcTotalPrice: ->
    total = 0.0
    $('.transfer_line').each (i, tl)->
      TransferProduct.recalcLineTotal $(tl)
      total += parseFloat $(tl).data('price')

    totalPrice = $('#total_price')

    totalPrice.html(totalPrice.html().match(/(^\D+)/)[0] + total.toFixed(2))

new Rule
  condition: -> $('#c_transfer_products').length
  load: ->
    @map.calcTotalPrice ||= ->
      TransferProduct.calcTotalPrice()

    $(document).on 'change keyup', '.price-modifier', @map.calcTotalPrice
    $(document).ajaxStop -> TransferProduct.calcTotalPrice()

  unload: ->
    $(document).off 'change keyup', '.price-modifier', @map.calcTotalPrice

