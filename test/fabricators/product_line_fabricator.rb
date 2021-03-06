Fabricator(:product_line) do
  product_id    { Fabricate(:product).id }
  quantity      { 100.0 * rand }
  unit_price    { 100.0 * rand }
  price         { 100.0 * rand }
  price_type    { Customer::PRICE_TYPE.sample }
  sale_id       { Fabricate(:sale).id }
end
