window.Product =
  updateAllPrices: ->
    value = $('#product_iva_cost').val()
    earn = $('#product_gain').val() / 100 + 1
    final_price = (value * earn).toFixed(2)

    $('#product_retail_price').attr('value', final_price)
    $('#product_unit_price').attr('value', final_price)
    $('#product_special_price').attr('value', final_price)

jQuery ($) ->
  $('#product_cost').on 'change keyup', () ->
    cost = $(this).val()
    $('#product_iva_cost').attr('value', (cost * 1.21).toFixed(2) ) #21% iva
    Product.updateAllPrices()

  $('.price-modifier').on 'change keyup', () ->
    Product.updateAllPrices()
