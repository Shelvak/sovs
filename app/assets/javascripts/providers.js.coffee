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
      selected = $(this).attr('value')
      $(province_select).removeOptions()
      switch selected
        when 'Mendoza' then $(province_select).addOptions(mendoza_cities)
        else
          $(province_select).addOptions(['Seleccione provincia por favor'])

  removeOptions: () ->
    select = "##{$(this).attr('id')} option"
    $(select).each (i,element) ->
      $(element).remove()

  addOptions: (array) ->
    target_select = this
    array.map (element) ->
      target_select.append(new Option(element))
  

jQuery ($) ->

  $('#provider_province').linkToStates('#provider_city')
  $('#provider_province').change()
