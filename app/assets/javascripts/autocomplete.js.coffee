jQuery ($)->
  $(document).on 'change', 'input.autocomplete-field', ->
    if /^\s*$/.test($(this).val())
      $(this).next('input.autocomplete-id:first').val('')
      
  $(document).on 'focus', 'input.autocomplete-field:not([data-observed])', ->
    input = $(this)

    input.autocomplete
      source: (request, response)->
        $.ajax
          url: input.data('autocompleteUrl')
          dataType: 'json'
          data: { q: request.term }
          success: (data)->
            response $.map data, (item)->
              content = $('<div></div>')

              content.append $('<span class="title"></span>').text(item.label)

              if item.informal
                content.append $('<small></small>').text(item.informal)

              { label: content.html(), value: item.label, item: item }
      type: 'get'
      select: (event, ui)->
        selected = ui.item

        input.val(selected.value)
        input.data('item', selected.item)
        $(input.data('autocompleteIdTarget')).val(selected.item.id)

        input.trigger 'autocomplete:update', input

        false
      open: -> $('.ui-menu').css('width', input.width())

    input.data('autocomplete')._renderItem = (ul, item)->
      $('<li></li>').data('item.autocomplete', item).append(
        $('<a></a>').html(item.label)
      ).appendTo(ul)
  .attr('data-observed', true)

  # Autocomplete with first item
  $(document).on 'change', 'input.autocomplete-field-without-ui', ->
    if (input = $(this)).val().length > 1
      $.ajax
        url: input.data('autocompleteUrl')
        dataType: 'json'
        data: { q: input.val() }
        success: (data)->
          if data.length
            item = data[0]
            $(input.data('autocompleteIdTarget')).val(item.id)
            $(input).val(item.label)

            if $(input.data('autocompleteUnitPriceTarget'))
              $(input.data('autocompleteUnitPriceTarget')).val(item.retail_price)

            Sale.updateTotalPrice()
