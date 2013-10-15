window.Product =
  updateAllPrices: ->
    unless State.gain_charged
      gain = $('#product_gain').val()
      unit_gain = $('#product_unit_gain').val()
      special_gain = $('#product_special_gain').val()

      unless gain && gain.length && gain > 0.0
        $('#product_gain').val(30)
      unless unit_gain && unit_gain.length && unit_gain > 0.0
        $('#product_unit_gain').val(30)
      unless special_gain && special_gain.length && special_gain > 0.0
        $('#product_special_gain').val(30)
      
    value = $('#product_iva_cost').val()
    gain = $('#product_gain').val() / 100 + 1
    unit_gain = $('#product_unit_gain').val() / 100 + 1
    special_gain = $('#product_special_gain').val() / 100 +1

    $('#product_retail_price').val((value * gain).toFixed(2))
    $('#product_unit_price').val((value * unit_gain).toFixed(2))
    $('#product_special_price').val((value * special_gain).toFixed(2))

  updateTotalStock: ->
    if $('#product_unity_relation').val().length && $('#product_total_stock').val().length

      total_packs = $('#product_total_stock').val() / $('#product_unity_relation').val()
      $('#product_packs').val(total_packs.toFixed(2))

new Rule
  load: ->
    @map.update_iva_cost ||= ->
      cost = $(this).val()
      $('#product_iva_cost').val((cost * 1.21).toFixed(2)) #21% iva
      Product.updateAllPrices()
      State.gain_charged = true
    @map.update_all_prices ||= ->
      Product.updateAllPrices()
      State.gain_charged = true
    @map.update_total_stock ||= ->
      Product.updateTotalStock()
    @map.put_to_stock ||= (e)->
      e.preventDefault()
      quantity = prompt(Message.quantity_to_put_in_stock)

      if quantity?
        window.location = this.href + '?quantity=' + parseFloat(quantity)
    
    $(document).keydown (e)->
      key = e.which

      # Imprimir stock faltante
      if e.ctrlKey && e.altKey && (key == 73 || key == 105)
        e.preventDefault()
        $('#print_low_stock_button').click()


    $(document).on 'keyup', '#product_cost', @map.update_iva_cost
    $(document).on 'keyup', '.price-modifier', @map.update_all_prices
    $(document).on 'keyup', '.stock-modifier', @map.update_total_stock
    $(document).on 'click', '.put_to_stock', @map.put_to_stock

  unload: ->
    $(document).off 'keyup', '#product_cost', @map.update_iva_cost
    $(document).off 'keyup', '.price-modifier', @map.update_all_prices
    $(document).off 'keyup', '.stock-modifier', @map.update_total_stock
    $(document).off 'click', '.put_to_stock', @map.put_to_stock
    State.gain_charged = false

