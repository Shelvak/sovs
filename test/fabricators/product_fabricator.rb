Fabricator(:product) do
  code            { 100000 * rand }
  description     { Faker::Lorem.sentence }
  retail_unit     { ['Kg', 'g', 'L', 'ml', 'Un'].sample }
  purchase_unit   { ['Kg', 'g', 'L', 'ml', 'Un'].sample }
  unity_relation  { 100.0 * rand }
  total_stock     { 100.0 * rand }
  min_stock       { 100.0 * rand }
  packs           { 100 * rand(100) }
  pack_content    { 100.0 * rand }
  cost            { 100.0 * rand }
  iva_cost        { 100.0 * rand }
  gain            { 100.0 * rand }
  retail_price    { 100.0 * rand }
  unit_price      { 100.0 * rand }
  special_price   { 100.0 * rand }
  unit_gain       { 100.0 * rand }
  special_gain    { 100.0 * rand }
  provider_id     { Fabricate(:provider).id }
end
