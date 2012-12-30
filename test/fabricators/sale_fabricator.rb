Fabricator(:sale) do
  customer_id   { Fabricate(:customer).id }
  seller_id     { Fabricate(:seller).id }
  sale_kind     { Faker::Lorem.word[0] }
  total_price   { 100.0 * rand }
end
