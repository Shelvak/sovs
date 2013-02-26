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

        if value = selected.item.default_price_type
          target.parents('.row-fluid').
            find('input[name$="[default_price_type]"]').val(value)
          $('.product_line').last().find('select[name$="[price_type]"]').val(value)

        input.trigger 'autocomplete:update', input

        false
      open: -> $('.ui-menu').css('width', input.width())

    input.data('autocomplete')._renderItem = (ul, item)->
      $('<li></li>').data('item.autocomplete', item).append(
        $('<a></a>').html(item.label)
      ).appendTo(ul)
  .attr('data-observed', true)

