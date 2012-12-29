module ProductsHelper
  def product_unit_array
    ['Kg', 'g', 'L', 'ml', 'Un']
  end

  def retail_unit_select_for_product(form)
    form.input :retail_unit, as: :select, collection: product_unit_array,
      selected: form.object.retail_unit, prompt: false, 
      input_html: { class: 'span6'}
  end

  def purchase_unit_select_for_product(form)
    form.input :purchase_unit, as: :select, collection: product_unit_array,
      selected: form.object.purchase_unit, prompt: false, 
      input_html: { class: 'span6' }
  end
end
