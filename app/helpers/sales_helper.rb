module SalesHelper
  def sale_kinds_array
    Customer::BILL_KINDS
  end

  def sale_kind_select_for_sale(form)
    form.input :sale_kind, collection: sale_kinds_array,
      selected: form.object.try(:sale_kind) || 'B', prompt: false,
      input_html: { class: 'span6 price-modifier' }
  end

  def price_type_select_for_product_line(form)
    price_type_select = Customer::PRICE_TYPE.map do |v|
      [t("view.customers.price_types.#{v}_abbr"), v]
    end

    form.input :price_type, collection: price_type_select,
      selected: form.object.price_type || :retail_price, prompt: false,
      label: false, input_html: { class: 'span10 price-modifier hide' }
  end
end
