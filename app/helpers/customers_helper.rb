module CustomersHelper

  def customer_kinds_for_select
    Customer::KINDS.map { |n, v| [t("view.customers.kinds.#{n}"), v] }
  end

  def translation_for_customer_kind(kind)
    t("view.customers.kinds.#{Customer::KINDS.invert[kind]}")
  end

  def bill_kind_select_for_customer(form)
    form.input :bill_kind, collection: Customer::BILL_KINDS,
      selected: form.object.bill_kind || 'B', prompt: false, 
      required: false, input_html: { class: 'span6' }
  end

  def iva_kind_select_for_customer(form)
    form.input :iva_kind, collection: customer_kinds_for_select,
      selected: form.object.iva_kind || 'F', prompt: false, 
      required: false, input_html: { class: 'span6' }
  end

  def default_price_type_select_for_customer(form)
    price_type_select = Customer::PRICE_TYPE.map do |v|
      [Product.human_attribute_name(v), v]
    end

    form.input :default_price_type, collection: price_type_select,
      selected: form.object.default_price_type, include_blank: true, 
      required: false, input_html: { class: 'span6' }
  end
end
