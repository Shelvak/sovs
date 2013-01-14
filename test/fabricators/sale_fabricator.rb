Fabricator(:sale) do
  customer_id   { Fabricate(:customer).id }
  seller_id     { Fabricate(:seller).id }
  seller_code   { |attrs| Seller.find(attrs[:seller_id]).code }
  sale_kind     { Faker::Lorem.word[0] }
  total_price   { 100.0 * rand }
  product_lines do 
    [ProductLine.new(Fabricate.attributes_for(:product_line, sale_id: nil))]
  end
end
