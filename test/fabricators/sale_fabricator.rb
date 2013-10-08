Fabricator(:sale) do
  customer_id   { Fabricate(:customer).id }
  seller_id     { Fabricate(:seller).id }
  seller_code   { |attrs| Seller.find(attrs[:seller_id]).code }
  sale_kind     { ['A', 'B'].sample }
  total_price   { 100.0 * rand }
  place_id      { Fabricate(:place).id }
  product_lines do 
    [ProductLine.new(Fabricate.attributes_for(:product_line, sale_id: nil))]
  end
end
