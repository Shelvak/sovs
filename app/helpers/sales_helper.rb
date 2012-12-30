module SalesHelper
  def sale_kinds_array
    ['-', 'A', 'B', 'C', 'X']
  end

  def sale_kind_select_for_sale(form)
    form.input :sale_kind, collection: sale_kinds_array,
      selected: form.object.sale_kind, prompt: false,
      input_html: { class: 'span6' }
  end
end
