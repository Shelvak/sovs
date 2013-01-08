window.Product =
  updateAllPrices: ->
    value = $('#product_iva_cost').val()
    earn = $('#product_gain').val()
    $('#product_gain').val(earn || 30)
    final_price = (value * (earn / 100 + 1)).toFixed(2)

    $('#product_retail_price').val(final_price)
    $('#product_unit_price').val(final_price)
    $('#product_special_price').val(final_price)

  updateTotalStock: ->
    total_stock = $('#product_packs').val() * $('#product_pack_content').val()
    $('#product_total_stock').val(total_stock.toFixed(2))

jQuery () ->
  $('#product_cost').on 'change keyup', () ->
    cost = $(this).val()
    $('#product_iva_cost').val((cost * 1.21).toFixed(2)) #21% iva
    Product.updateAllPrices()

  $('.price-modifier').on 'change keyup', () ->
    Product.updateAllPrices()

  $('.stock-modifier').on 'change keyup', () ->
    Product.updateTotalStock()
