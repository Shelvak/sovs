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

  def link_to_low_stock_products
    count = Product.with_low_stock.count
    classes = ['badge']
    classes << 'badge-important' if count > 0
    count_tag = content_tag(
      :span, count, class: classes.join(' ')
    )
    
    link_to raw(count_tag), products_path(status: 'low_stock'), 
      title: t('view.products.low_stock')
  end

  def print_low_stock_button
    text = t('view.products.print_low_stock')
    link_to text, print_low_stock_path, title: text,
      class: 'btn btn-mini', id: 'print_low_stock_button', 
      data: { method: :put, remote: true, show_tooltip: true }
  end
end
