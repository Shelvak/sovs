Fabricator(:transfer_line) do
  product_id            { Fabricate(:product).id }
  quantity              { (100 * rand).round(3) }
  transfer_product_id   { Fabricate(:transfer_product).id }
  price                 { 100 * rand }
end
