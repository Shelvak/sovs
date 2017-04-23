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
      label: false, input_html: { class: 'span11 price-modifier' }
  end

  def _hidden_and_disabled_temp_input(form, field)
    form.input "#{field}_tmp", as: :hidden, input_html: { disabled: true, value: form.object.try(field) }
  end

  def product_price_inputs(form)
    inputs = _hidden_and_disabled_temp_input(form, 'retail_price')
    inputs << _hidden_and_disabled_temp_input(form, 'unit_price')
    inputs << _hidden_and_disabled_temp_input(form, 'special_price')
    inputs
  end
end
