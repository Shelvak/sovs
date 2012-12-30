Fabricator(:product_line) do
  product_id    { Fabricate(:product),id }
  quantity      { 100.0 * rand }
  price         { 100.0 * rand }
  sale_id       { Fabricate(:sale).id }
end
