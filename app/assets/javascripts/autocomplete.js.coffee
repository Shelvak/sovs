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
        target = $(input.data('autocompleteIdTarget'))
        target.val(selected.item.id)

        if classTarget = input.data('autocompleteClassTarget')
          input.parents(input.data('autocompleteParent'))
            .find(classTarget).val(selected.item.id)

        if value = selected.item.default_price_type
          target.parents('.row-fluid').
            find('input[name$="[default_price_type]"]').val(value)
          $('.product_line').last().find('select[name$="[price_type]"]').val(value)
        if (bill_kind = selected.item.bill_kind)
          $('#sale_sale_kind').val(bill_kind).change()

        input.trigger 'autocomplete:update', input

        if focusTarget = input.data('focus-target')
          $(focusTarget).focus()

        false
      open: -> $('.ui-menu').css('width', input.width())

    input.data('ui-autocomplete')._renderItem = (ul, item)->
      $('<li></li>').data('item.autocomplete', item).append(
        $('<a></a>').html(item.label)
      ).appendTo(ul)
  .attr('data-observed', true)

  $(document).on 'change', 'input.autocomplete-field-after-tab:not([data-observed])', ->
    if (input = $(this)).val().length > 0
      console.log(input.val())
      $.ajax
        url: input.data('autocompleteUrl')
        dataType: 'json'
        data: { q: input.val() }
        success: (item)->
          if item
            $(input.data('autocompleteIdTarget')).val(item.id)
            $(input).val(item.label)

            if item.retail_unit
              $(input).parents('.row-fluid:first')
                .find('span[data-retail-unit]').html(item.retail_unit)

            if item.iva_cost
              ivaCost = $(input).parents('.row-fluid:first').find('span[data-iva-cost]')
              ivaCost.html(ivaCost.html().replace(/\d+[,|.]\d+/, item.iva_cost))
