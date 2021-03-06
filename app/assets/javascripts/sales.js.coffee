window.Sale =
  fillProductPrices: (input, item) ->
    target = $(input.data('autocompleteIdTarget'))
    target.val(item.id)
    $(input).val(item.label)

    parent = target.parents('.product_line:first')
    if item.retail_price
      parent.find('input[name$="[retail_price_tmp]"]').val(item.retail_price)

    if item.unit_price
      parent.find('input[name$="[unit_price_tmp]"]').val(item.unit_price)

    if item.special_price
      parent.find('input[name$="[special_price_tmp]"]').val(item.special_price)

    parent.find('select[name$="[price_type]"]').val('retail_price').change()

    Sale.updateTotalPrice()

  updateLinePrice: (product_line)->
    quantity = parseFloat product_line.find('input[name$="[quantity]"]').val()
    price_type = product_line.find('select[name$="[price_type]"]').val()

    kind = $('#sale_sale_kind').val()
    divider = if kind == 'A' then 1.21 else 1

    unit_price = parseFloat(
      product_line.find("input[name$='[#{price_type}_tmp]']").val()
    )

    if unit_price
      unit_price = (unit_price / divider).toFixed(2)
      product_line.find('input[name$="[unit_price]"]').val(unit_price)

    line_price = ((quantity || 0) * (unit_price || 0)).toFixed(2)
    product_line.find('span.money').html("$ #{line_price}")
    product_line.attr('data-price', line_price)
    product_line.find('input[name$="[price]"]').val(line_price)

  updateTotalPrice: () ->
    totalPrice = 0.0
    $('.product_line').each (i, element)->
      Sale.updateLinePrice($(this))
      totalPrice += parseFloat($(this).attr('data-price')) || 0

    if $('#sale_sale_kind').val() == 'A'
      $('#neto-price').find('span').html("$ #{totalPrice.toFixed(2)}")
      ivaPrice = (totalPrice * 1.21) - totalPrice
      $('#iva-price').find('span').html("$ #{ivaPrice.toFixed(2)}")
      totalPrice *= 1.21

    $('#sale_total_price').val(totalPrice.toFixed(2))

  add_nested_btn: '.btn.btn-small[data-dynamic-form-event="addNestedItem"]'
  delete_nested_link: 'a[data-dynamic-form-event="removeItem"]'

  toggleNetoPrice: ()->
    action = if $('#sale_sale_kind').val() == 'A' then 'show' else 'hide'
    EffectHelper[action]($('div#neto-price, div#iva-price'))

  blankAllPrices: (product_line)->
    product_line.find('input[name$="[unit_price]"]').val(0.00)
    product_line.find('input[name$="[retail_price_tmp]"]').val(0.00)
    product_line.find('input[name$="[unit_price_tmp]"]').val(0.00)
    product_line.find('input[name$="[special_price_tmp]"]').val(0.00)
    product_line.find('select[name$="[price_type]"]').val('retail_price').change()
    Sale.updateTotalPrice()

new Rule
  condition: -> $(Sale.add_nested_btn).length
  load: ->
    add_nested_btn = $(Sale.add_nested_btn)

    # Endless add nested =)
    add_nested_btn.attr('tabindex')
    add_nested_btn.attr('tabindex', 3)
    add_nested_btn.on 'focus', -> $(this).click()

    # Captura de atajos de teclado
    $(document).keydown (e)->
      key = e.which

      # Cambiar Venta
      # Ctrol + Alt + F
      if e.ctrlKey && e.altKey && (key == 70 || key == 102)
        e.preventDefault()
        select = $('#sale_sale_kind')
        if select.val() == 'B'
          select.val('A').change()
        else
          select.val('B').change()

      # Ctrol + Alt + C
      if e.ctrlKey && e.altKey && (key == 67 || key == 99)
        e.preventDefault()
        $('#sale_auto_customer_name').focus()

      # Enter without Ctrol
      if key == 13 && !e.ctrlKey
        input = $(document.activeElement)
        input_id = input.attr('id')

        if input.data('enter-scape')

          e.preventDefault()
          e.stopPropagation()

          if input_id.match(/(seller_code)/)
            $('input[tabindex=2]:first').focus()
          else if input_id.match(/(product_name)/)
            add_nested_btn.focus()
            # input_number = input_id.match(/(\d+)/)[1]

            #$("input[name$=\"[#{input_number}][quantity]\"]").focus()
          else if input_id.match(/(quantity)|(provider)/)
            add_nested_btn.focus()

      # Ctrol + Enter
      else if key == 13 && e.ctrlKey
        $('form').submit()

    @map.update_lines_price ||= ->
      Sale.updateTotalPrice()

    @map.select_default_price_type ||= ->
      if (value = $('input[name$="[default_price_type]"]').val())
        $('.product_line').last().find('select[name$="[price_type]"]').val(value)

    @map.autocomplete_for_product_sale ||= ->
      input = $(this)
      value = input.val()
      parent = input.parents('.product_line:first')

      if value.length > 0
        # Skip ajax call on common-autocomplete
        if /^\[\d+\] \w+/.test(value)
          return

        data = input.val()

        $.ajax
          url: input.data('autocompleteUrl')
          dataType: 'json'
          data: { q: data }
          success: (data)->
            if data.length
              Sale.fillProductPrices(input, data[0])
            # else
            #   Sale.blankAllPrices(parent)
      else
        Sale.blankAllPrices(parent)

    @map.clearAutoComplete ||= ->
      input = $(this)
      if /^\s*$/.test(input.val())
        Sale.blankAllPrices(input.parents('.product_line:first'))

    @map.update_price_with_delay ||= ->
      setTimeout (-> Sale.updateTotalPrice()), 1000

    @map.updatePriceTypeSpan ||= ->
      parent = $(this).parents('.product_line:first')
      parent.find('span[data-price-type]').html(
        parent.find('select[name$="[price_type]"] option:selected').text()
      )


    $(document).on 'keyup change focus', '.price-modifier', @map.update_lines_price
    $(document).on 'change', 'input.autocomplete-field-for-product-sale',
      @map.autocomplete_for_product_sale
    $(document).on 'click', Sale.add_nested_btn, @map.select_default_price_type
    $(document).on 'change', '#sale_sale_kind', Sale.toggleNetoPrice
    $(document).on 'click', Sale.delete_nested_link, @map.update_price_with_delay
    $(document).on 'keyup', 'input.autocomplete-field-for-product-sale', @map.clearAutoComplete
    $(document).on 'change', 'select[name$="[price_type]"]', @map.updatePriceTypeSpan

  unload: ->
    $(document).off 'keyup change focus', '.price-modifier', @map.update_lines_price
    $(document).off 'change', 'input.autocomplete-field-for-product-sale',
      @map.autocomplete_for_product_sale
    $(document).off 'click', Sale.add_nested_btn, @map.select_default_price_type
    $(document).off 'change', '#sale_sale_kind', Sale.toggleNetoPrice
    $(document).off 'click', Sale.delete_nested_link, @map.update_price_with_delay
    $(document).off 'keyup', 'input.autocomplete-field-for-product-sale', @map.clearAutoComplete
    $(document).off 'change', 'select[name$="[price_type]"]', @map.updatePriceTypeSpan


