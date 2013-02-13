window.Sale =
  updateLinePrice: (product_line)->
    quantity = parseFloat product_line.find('input[name$="[quantity]"]').val()
    unit_price = parseFloat product_line.find('input[name$="[unit_price]"]').val()

    line_price = ((quantity || 0) * (unit_price || 0)).toFixed(2)
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

    @map.update_lines_price ||= ->
      Sale.updateTotalPrice()

    $(document).on 'keyup change focus', '.price-modifier', @map.update_lines_price

  unload: ->
    $(document).off 'keyup change focus', '.price-modifier', @map.update_lines_price
