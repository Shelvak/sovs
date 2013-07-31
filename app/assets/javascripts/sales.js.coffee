window.Sale =
  updateLinePrice: (product_line)->
    quantity = parseFloat product_line.find('input[name$="[quantity]"]').val()
    price_type = product_line.find('select[name$="[price_type]"]').val()
    unit_price = parseFloat(
      product_line.find("input[name$='[#{price_type}_tmp]']").val()
    )

    line_price = ((quantity || 0) * (unit_price || 0)).toFixed(2)
    if unit_price
      product_line.find('input[name$="[unit_price]"]').val(unit_price)
    product_line.find('span.money').html("$ #{line_price}")
    product_line.attr('data-price', line_price)
    product_line.find('input[name$="[price]"]').val(line_price)

  updateTotalPrice: () ->
    totalPrice = 0.0
    $('.product_line').each (i, element)->
      Sale.updateLinePrice($(this))
      totalPrice += parseFloat($(this).attr('data-price')) || 0

    $('#sale_total_price').val(totalPrice.toFixed(2))

  add_nested_btn: '.btn.btn-small[data-dynamic-form-event="addNestedItem"]'



new Rule
  condition: -> $(Sale.add_nested_btn).length
  load: ->
    add_nested_btn = $(Sale.add_nested_btn)
    new_title = add_nested_btn.attr('data-original-title') + ' (CTROL + ALT + A)'
    add_nested_btn.attr('data-original-title', new_title)

    # Endless add nested =)
    add_nested_btn.attr('tabindex')
    add_nested_btn.attr('tabindex', 3)
    add_nested_btn.on 'focus', -> $(this).click()

    # Captura de atajos de teclado
    $(document).keydown (e)->
      key = e.which

      if e.ctrlKey && e.altKey && (key == 65 || key == 97)
        e.preventDefault()
        add_nested_btn.click()

      if key == 13 && !e.ctrlKey
        input = $(document.activeElement)
        input_id = input.attr('id')
        
        if input.data('enter-scape')

          e.preventDefault()
          e.stopPropagation()

          if input_id.match(/(seller_code)/)
            $('input[tabindex=2]:first').focus()
          else if input_id.match(/(product_name)/)
            input_number = input_id.match(/(\d+)/)[1]
            $("input[name$=\"[#{input_number}][quantity]\"]").focus()
          else if input_id.match(/(quantity)/)
            add_nested_btn.focus()

      else if key == 13 && e.ctrlKey
        $('form').submit()

    @map.update_lines_price ||= ->
      Sale.updateTotalPrice()

    @map.select_default_price_type ||= ->
      if (value = $('input[name$="[default_price_type]"]').val())
        $('.product_line').last().find('select[name$="[price_type]"]').val(value)
        
    @map.autocomplete_for_product_sale ||= ->
      if (input = $(this)).val().length > 0
        $.ajax
          url: input.data('autocompleteUrl')
          dataType: 'json'
          data: { q: input.val() }
          success: (data)->
            if data.length
              item = data[0]
              target = $(input.data('autocompleteIdTarget'))
              target.val(item.id)
              $(input).val(item.label)

              parent = target.parents('.product_line')
              if item.retail_price
                parent.find('input[name$="[retail_price_tmp]"]').val(item.retail_price)

              if item.unit_price
                parent.find('input[name$="[unit_price_tmp]"]').val(item.unit_price)

              if item.special_price
                parent.find('input[name$="[special_price_tmp]"]').val(item.special_price)

              Sale.updateTotalPrice()

    $(document).on 'keyup change focus', '.price-modifier', @map.update_lines_price
    $(document).on 'change', 'input.autocomplete-field-for-product-sale',
      @map.autocomplete_for_product_sale
    $(document).on 'click', Sale.add_nested_btn, @map.select_default_price_type

  unload: ->
    $(document).off 'keyup change focus', '.price-modifier', @map.update_lines_price
    $(document).off 'change', 'input.autocomplete-field-for-product-sale',
      @map.autocomplete_for_product_sale
    $(document).off 'click', Sale.add_nested_btn, @map.select_default_price_type


