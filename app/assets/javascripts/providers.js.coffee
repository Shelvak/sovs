# For future gem ^^
argentina_provinces = [
  "Capital Federal", "Buenos Aires", "Catamarca", "Córdoba", "Corrientes", "Chaco",
  "Chubut", "Entre Ríos", "Formosa", "Jujuy", "La Pampa", "La Rioja", "Mendoza",
  "Misiones", "Neuquén", "Río Negro", "Salta", "San Juan", "San Luis", "Santa Cruz", 
  "Santa Fe", "Santiago del Estero", "Tierra del Fuego", "Tucumán"
]

mendoza_cities = [
  'Capital', 'General Alvear', 'Godoy Cruz', 'Guaymallén', 'Junín', 'La Paz',
  'Las Heras', 'Lavalle', 'Luján de Cuyo', 'Maipú', 'Malargüe', 'Rivadavia',
  'San Carlos', 'San Martín', 'San Rafael', 'Santa Rosa', 'Tunuyán', 'Tupungato'
]

$.fn.extend
  linkToStates: (province_select) ->
    $(this).on 'change', () ->
      selected = $(this).val()
      $(province_select).removeOptions()
      switch selected
        when 'Mendoza' then $(province_select).addOptions(mendoza_cities)
        else
          $(province_select).addOptions(['Provincia sin departamentos cargados'])

  removeOptions: () ->
    select = "##{$(this).attr('id')} option"
    $(select).each (i,element) ->
      $(element).remove()

  addOptions: (array) ->
    target_select = this
    array.map (element) ->
      target_select.append(new Option(element))
  
new Rule
  condition: -> $('#c_providers').length
  load: ->
    @map.increase_provider_prices ||= ->
      increase = prompt('Ingrese el % de aumento')
      parse = parseFloat(increase)
      if $.isNumeric(parse) && parse != 0.00
        window.location = window.location.pathname + '/add_increase?add=' + increase
      else
        alert('No ha ingresado un valor correcto')
    @map.activate_province_select ||= ->
      $(this).linkToStates('#provider_city')

    @map.focusLastAutoProvider ||= ->
      $('[data-provider]:last input').focus()


    $(document).on 'click', '#add_provider_increase', @map.increase_provider_prices
    $(document).on 'change', '#provider_province', @map.activate_province_select
    $(document).on 'click focus', Sale.add_nested_btn, @map.focusLastAutoProvider

  unload: ->
    $(document).off 'click', '#add_provider_increase', @map.increase_provider_prices
    $(document).off 'change', '#provider_province', @map.activate_province_select

