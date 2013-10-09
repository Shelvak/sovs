jQuery ($)->
  if $('#graph').length > 0
    # Graphic calculations

    container = $('#graph')
    width = container.innerWidth()
    [values, labels] = [[], []]

    $('table[data-graph-grid] tbody tr').each ->
      values.push parseInt($(this).find('td[data-value-column]').text().replace('$', ''))
      labels.push "%%.%% #{$(this).find('td[data-label-column]').text()}"

    if $('.piechart').length > 0
      pie = Raphael(container.get(0), width, 500).piechart(
        220, 220, 175, values,
        legend: labels,
        legendpos: 'east',
        legendothers: "%%.%% #{$('table[data-graph-grid]').data('othersLabel')}",
        stroke: '#efefef',
        strokewidth: 2
      )
      
      pie.hover ->
        this.sector.stop()
        this.sector.scale 1.1, 1.1, this.cx, this.cy

        if this.label
          this.label[0].stop()
          this.label[0].attr r: 7.5
          this.label[1].attr 'font-weight': 800
      , ->
        this.sector.animate transform: "s1 1 #{this.cx} #{this.cy}", 500, 'bounce'
        
        if this.label
          this.label[0].animate r: 5, 500, 'bounce'
          this.label[1].attr 'font-weight': 400

    if $('.barchart').length > 0
      bar = Raphael(container.get(0), width, 500)
      chart = bar.barchart(
        1, 1, width, 500, values
      )

      chart.hover ->
        $(
          "tr[data-row-id='#{this.bar.id}']"
        ).addClass('alert-success')
      , ->
        $(
          "tr[data-row-id='#{this.bar.id}']"
        ).removeClass('alert-success')

         
